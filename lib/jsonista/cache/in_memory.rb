module Jsonista
  module Cache
    class InMemory
      attr_reader :cache

      def initialize( initial_state = {} )
        @cache = initial_state
      end

      def fetch( key, &value_assignment_block )
        @cache.fetch( key ) do
          raise Jsonista::Cache::UnknownKey unless value_assignment_block
          @cache[key] = value_assignment_block.call
        end
      end

      def store( key, value )
        @cache[key] = value
      end

      def invalidate( *keys )
        keys.each do |key|
          @cache.delete( key )
        end
      end

      def clear!
        @cache.clear
      end
    end
  end
end
