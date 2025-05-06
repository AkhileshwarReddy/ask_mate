module Cacheable
    extend ActiveSupport::Concern

    def fetch_cache(key, expires_in: 5.minutes, &block)
        Rails.cache.fetch(key, expires_in: expires_in, &block)
    end

    def expire_matched_cache(pattern)
        Rails.cache.delete_matched(pattern)
    end

    def expire_cache(key)
        Rails.cache.delete(key)
    end
end
