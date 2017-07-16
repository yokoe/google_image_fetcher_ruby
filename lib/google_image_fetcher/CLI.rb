require "json"
require "open-uri"
require "thor"
require "faraday"
require_relative "./fetcher"

module GoogleImageFetcher
  class CLI < Thor
    desc "search", "Fetch images from Google"
    option :page_max, :default => 0, :type => :numeric
    def search(query)
      page_max = options[:page_max]
      for page in 0..page_max
        search_url = Fetcher.search_url(query, page)
        conn = Faraday.new(url: search_url)
        response = conn.get
        result = JSON.parse(response.body)
        image_url = result["items"].map {|item| item["link"] }
        Fetcher.store(query, image_url)
      end
    end
  end
end
