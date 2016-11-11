require 'fb_share_count/version'
require 'fb_share_count/share_count_cache'

module FbShareCount
  class << self
    attr_accessor :cache_store,
                  :cache_expire_time

    def configure
      yield self
    end

    def get_for_urls(urls)
      ShareCountCache.get urls
    rescue => e
      handle_error e
      nil
    end

    def handle_errors(&block)
      @error_handler = block
    end

    def handle_error(error)
      return unless @error_handler
      @error_handler.call error
    end
  end
end
