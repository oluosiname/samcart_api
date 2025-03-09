# frozen_string_literal: true

module SamcartApi
  class Paginator
    def initialize(client, path, params)
      @client = client
      @next_url = "#{path}?#{params.to_query}"
      @retry_attempts = 3
    end

    def next_page?
      !@next_url.nil?
    end

    def next_page
      return unless next_page?

      response = client.get(@next_url)
      @next_url = response.dig('pagination', 'next')
      response['data']
    end

    def each_page
      yield next_page while next_page?
    end

    attr_reader :client
  end
end
