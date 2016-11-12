require 'redis'

module FbShareCount
  class CacheStore
    class << self
      def get(key)
        FbShareCount.logger.debug { "Getting #{key} from cache" }
        store.get key
      end

      def set(key, value)
        FbShareCount.logger.debug { "Setting #{value} for #{key} in cache" }
        store.set key, value
        store.expire key, expire_time
      end

      private

      def store
        FbShareCount.cache_store
      end

      def expire_time
        FbShareCount.cache_expire_time
      end
    end
  end
end
