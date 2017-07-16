require "uri"
module GoogleImageFetcher
  class Fetcher
    class << self
      def search_url(query, page)
        api_key = ENV["GOOGLE_API_KEY"]
        engine_id = ENV["SEARCH_ENGINE_ID"]
        params = {
          "key" => api_key,
          "cx" => engine_id,
          "q" => query,
          "searchType" => "image"
        }
        params["start"] = page * 10 + 1 if page > 0
        url = "https://www.googleapis.com/customsearch/v1?#{URI.encode_www_form(params)}"
      end

      def store(dir_path, image_url)
        FileUtils.mkdir_p(dir_path)

        image_url.each do |url|
          filename = "#{dir_path}/#{File.basename(url)}"
          open(filename, 'wb') do |file|
            open(url) do |data|
              file.write(data.read)
            end
          end
        end
      end
    end
  end
end
