module Jsonista
  class CachedValue
    attr_reader :key, :cache_miss_block

    def initialize( key, &cache_miss_block )
      @key = key
      @cache_miss_block = cache_miss_block
    end

    def resolve
      Jsonista.cache.fetch( key )

    rescue Jsonista::Cache::UnknownKey
      raise unless cache_miss_block

      structure = cache_miss_block.call
      serialized = Serializer.new.serialize( structure )
      Jsonista.cache.store( key, serialized )
      serialized
    end
  end
end
