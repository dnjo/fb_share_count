require 'httparty'

module FbShareCount
  class ShareCountClient
    class << self
      def call(urls)
        request_info urls, 50, {}
      end

      private

      def request_info(urls, count, info)
        urls.each_slice count do |url_group|
          response = request_urls url_group
          parsed_info = parse_response response, url_group
          info.merge! parsed_info
        end
        info
      end

      def request_urls(urls)
        ids = urls.join ','
        FbShareCount.logger.info { "Requesting share count for URLs: #{ids}" }
        response = HTTParty.get base_url,
                                query: { ids: ids }
        body = response.body.to_s
        FbShareCount.logger.info { "Share count response: #{body}" }
        JSON.parse body, symbolize_names: true
      rescue => e
        FbShareCount.handle_error e
        nil
      end

      def parse_response(response, url_group)
        url_group.each_with_object({}) do |url, url_info|
          info = response ? response[url.to_sym] : nil
          url_info[url] = get_share_info info
        end
      end

      def get_share_info(info)
        default_share_info = {
          comment_count: 0,
          share_count: 0
        }
        return default_share_info unless info && info[:share]
        default_share_info.merge info[:share]
      end

      def base_url
        'http://graph.facebook.com'
      end
    end
  end
end
