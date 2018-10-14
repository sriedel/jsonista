module Jsonista
  module DSL
    module Cache
      def cache( key, &cache_miss_block)
        ::Jsonista::CachedValue.new( key, &cache_miss_block )
      end
      module_function :cache
    end
  end
end
