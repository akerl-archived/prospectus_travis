require 'keylime'
require 'travis'

module ProspectusTravis
  GOOD_STATUSES = %w[created received started passed].freeze

  FAKE_BUILD = Struct.new(:state)

  ##
  # Lookup describes a TravisCI lookup
  class Lookup
    def initialize(repo_slug)
      @repo_slug = repo_slug
    end

    def expected
      @expected ||= GOOD_STATUSES.include?(actual) ? actual : 'passed'
    end

    def actual
      @actual ||= last_build.state
    end

    private

    def client
      @client ||= Travis::Client.new(uri: uri, access_token: token)
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

  ##
  # Helper for automatically adding build status check
  class Build < Module
    def initialize(repo_slug)
      @repo_slug = repo_slug || raise('No repo specified')
    end

    def extended(other) # rubocop:disable Metrics/MethodLength
      lookup = Lookup.new(@repo_slug)

      other.deps do
        item do
          name 'travis'

          expected do
            static
            set lookup.expected
          end

          actual do
            static
            set lookup.actual
          end
        end
      end
    end
  end
end
