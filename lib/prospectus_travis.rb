require 'keylime'
require 'travis'

module ProspectusTravis
  GOOD_STATUSES = %w[created received started passed].freeze

  FAKE_BUILD = Struct.new(:state)

  ##
  # Helper for automatically adding build status check
  class Build < Module
    def initialize(repo_slug)
      @repo_slug = repo_slug || raise('No repo specified')
    end

    def extended(other) # rubocop:disable Metrics/MethodLength
      actual_val, expected_val = parse_status

      other.deps do
        item do
          name 'travis'

          expected do
            static
            set expected_val
          end

          actual do
            static
            set actual_val
          end
        end
      end
    end

    private

    def client
      @client ||= Travis::Client.new(uri: uri, access_token: token)
    end

    def parse_status
      return [status, status] if GOOD_STATUSES.include?(status)
      [status, 'passed']
    end

    def status
      @status ||= last_build.state
    end

    def last_build
      @last_build ||= repo.last_build || FAKE_BUILD.new('no_results')
    end

    def repo
      @repo ||= client.repo(@repo_slug)
    end

    def uri
      @uri ||= Travis::Client::COM_URI
    end

    def token
      return @token if @token
      credential = Keylime.new(server: uri)
      msg = 'TravisCI Token (run `travis token --com` to generate)'
      @token = credential.get!(msg).password
    end
  end
end
