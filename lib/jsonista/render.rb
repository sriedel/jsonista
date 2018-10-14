module Jsonista
  module Render
    class TemplateResolver
      TEMPLATE_FILE_EXTENSION = ".jsonista".freeze

      def initialize( file, caller_path = nil, is_partial: false )
        @file = file
        @caller_path = caller_path
        @is_partial = is_partial
        STDERR.puts "Caller path: #{caller_path.inspect}"
      end

      def template_path
        if @is_partial
          path = File.split( @file )
          path[-1] = "_#{path[-1]}"
          @file = File.join( path )
        end
        ensure_file_extension_is_present
        expand_file_to_full_path
      end

      private

      def ensure_file_extension_is_present
        @file << TEMPLATE_FILE_EXTENSION unless @file.end_with?( TEMPLATE_FILE_EXTENSION )
      end

      def expand_file_to_full_path
        return @file if @file.start_with?( "/" )

        caller_path = @caller_path || "."

        caller_path_list = File.split( caller_path )
        caller_path_list.pop
        File.absolute_path( File.join( *caller_path_list, @file ) )
      end
    end

    def render( *args )
      options = args.pop if args.dig(-1).is_a?( Hash )
      options ||= {}
      file = args[0]

      if ![ file, options[:partial], options[:template], options[:string] ].one?
        raise NoTemplateError.new( "Must give only one of file argument, or one of the options :partial, :template, or :string" )
      end

      resolved_template_file = if file
                                 file
                               elsif options[:string]
                                 "(inline template)"
                               else
                                 template_file = options[:partial] || options[:template]
                                 resolver = TemplateResolver.new( template_file, caller_locations[0]&.path, is_partial: options[:partial] )
                                 resolver.template_path
                               end

      template_body = options[:string] || File.read( resolved_template_file )
      structure = Compiler.new( template_body, resolved_template_file ).compile
      Serializer.new.serialize( structure )
    end
    module_function :render
  end
end
