require 'keylime'
require 'travis'

module ProspectusTravis
  GOOD_STATUSES = %w[created received started passed].freeze

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
          name 'circleci'

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
      @client ||= Travis::Client.new(uri, access_token: token)
    end

    def parse_status
      return [status, status] if GOOD_STATUSES.include?(status)
      [status, 'passed']
    end

    def status
      @status ||= client.repo(@repo_slug).last_build.state
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
