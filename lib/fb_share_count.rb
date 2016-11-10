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
    end
  end
end
