module Jsonista
  module DSL
    module Render
      class TemplateResolver
        TEMPLATE_FILE_EXTENSION = ".jsonista".freeze

        attr_reader :template_filename

        def initialize( file, caller_path = nil, is_partial: false )
          @file = file
          @caller_path = caller_path
          @is_partial = is_partial
          @template_dirname, @template_filename = File.split( @file )
        end

        def full_template_path
          return instance_variable_get( :@full_template_path ) if instance_variable_defined?( :@full_template_path )

          filename = @is_partial ? "_#{template_filename}" : template_filename.dup
          filename << TEMPLATE_FILE_EXTENSION unless filename.end_with?( TEMPLATE_FILE_EXTENSION )

           @template_dirname.start_with?( "/" ) ? 
                                  File.join( @template_dirname, filename) :
                                  File.absolute_path( File.join( File.dirname( @caller_path ), @template_dirname, filename ) )
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
                                   resolver.full_template_path
                                 end

        template_body = options[:string] || File.read( resolved_template_file )
        
        compiler = Compiler.new( template_body, resolved_template_file )
        if options[:collection]
          options[:collection].each do |collection_element|
            local_variables = options[:locals] ? 
                                options[:locals].merge( :instance => collection_element ) :
                                { :instance => collection_element }
            compiler.compile( local_variables )
          end

        else
          compiler.compile( options[:locals] )
        end
      end
      module_function :render
    end
  end
end
