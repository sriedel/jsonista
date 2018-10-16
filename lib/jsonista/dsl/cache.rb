module Jsonista
  module DSL
    module Cache
      def cache( key, &cache_miss_block)
        ::Jsonista::CachedValue.new( key, &cache_miss_block )
      end
      alias __cache__ cache
      module_function :cache
      module_function :__cache__
    end
  end
end
