module Jsonista
  class CachePlaceholder
    attr_reader :key, :cache_miss_block

    def initialize( key, &cache_miss_block )
      @key = key
      @cache_miss_block = cache_miss_block
    end

    def resolve
      'this value is cached'
    end
  end
end
