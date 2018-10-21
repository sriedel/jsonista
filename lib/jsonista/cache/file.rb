module Jsonista
  module Cache
    class File
      DEFAULT_CACHE_PATH = ::File.join( Dir.pwd, "jsonista_cache" )

      attr_reader :cache_root_path

      def initialize( cache_root = DEFAULT_CACHE_PATH )
        @cache_root_path = cache_root
      end

      def fetch( key, &value_assignment_block )
        return ::File.read( path_for_key( key ) ) if ::File.exist?( path_for_key( key ) )
        raise Jsonista::Cache::UnknownKey unless value_assignment_block

        store( key, value_assignment_block.call )
      end

      def store( key, value )
        key_file = path_for_key( key )
        key_cache_dir = ::File.dirname( key_file )
        FileUtils.mkdir_p( key_cache_dir )
        ::File.write( key_file, value )
        value
      end

      def invalidate( *keys )
        key_files = keys.map { |key| path_for_key( key ) }
        FileUtils.rm( key_files, force: true )
      end

      def clear!
        ::FileUtils.rm_r( cache_root_path, secure: true )
        ::FileUtils.mkdir_p( cache_root_path )
      end

      private
      def path_for_key( key )
        ::File.join( cache_root_path, key.to_s )
      end
    end
  end
end
