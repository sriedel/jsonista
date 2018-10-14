module Jsonista
  module Cache
    def cache( key, &cache_miss_block)
      CachePlaceholder.new( key, &cache_miss_block )
    end
    module_function :cache
  end
end
