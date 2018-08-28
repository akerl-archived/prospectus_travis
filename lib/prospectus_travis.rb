require 'keylime'
require 'open-uri'

module ProspectusCircleci
  GOOD_STATUSES = %w[success fixed running new not_running scheduled].freeze

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

    def parse_status
      return [status, status] if GOOD_STATUSES.include?(status)
      [status, 'success']
    end

    def status
      return @status if @status
      build = api_req("project/github/#{@repo_slug}").first
      @status = build ? build['status'] : 'new'
    end

    def api_req(path)
      JSON.parse(open(url(path)).read) # rubocop:disable Security/Open
    end

    def url(path)
      "#{base_url}/api/v1.1/#{path}?circle-token=#{token}"
    end

    def base_url
      'https://circleci.com'
    end

    def token
      return @token if @token
      credential = Keylime.new(server: base_url)
      msg = "CircleCI Token (#{base_url}/account/api)"
      @token = credential.get!(msg).password
    end
  end
end
