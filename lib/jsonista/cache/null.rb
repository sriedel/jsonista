module Jsonista
  module Cache
    class Null
      def cache
        nil
      end

      def fetch( key, &value_assignment_block )
        raise Jsonista::Cache::UnknownKey unless value_assignment_block
        value_assignment_block.call
      end

      def store( key, value )
      end

      def invalidate( *keys )
      end

      def clear!
      end
    end
  end
end
