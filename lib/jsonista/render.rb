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

      return options[:string] if options[:string]

      template_file = file || options[:partial] || options[:template]

      template_body = if options[:partial]
                        resolver = TemplateResolver.new( template_file, caller_locations[0]&.path, is_partial: true )
                        File.read( resolver.template_path )

                      elsif options[:template]
                        resolver = TemplateResolver.new( template_file, caller_locations[0]&.path, is_partial: false )
                        File.read( resolver.template_path )

                      elsif options[:string]
                        options[:string]

                      elsif file
                          File.read( file )

                      else
                        raise NoTemplateError.new( "Must give either a filename as first parameter, or a :partial, :template or :string option" )
                      end
      Builder.new( template_body ).build
    end
    module_function :render
  end
end
