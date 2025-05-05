module Cacheable
    extend ActiveSupport::Concern

    def fetch_cache(key, expires_in: 5.minutes, &block)
        Rails.cache.fetch(key, expires_in: expires_in, &block)
    end
end
