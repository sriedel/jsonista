module Jsonista
  module Render
    TEMPLATE_FILE_EXTENSION = ".jsonista".freeze

    def render( *args )
      options = args.pop if args.dig(-1).is_a?( Hash )
      options ||= {}
      file = args[0]

      if ![ file, options[:partial], options[:template], options[:string] ].one?
        raise NoTemplateError.new( "Must give only one of file argument, or one of the options :partial, :template, or :string" )
      end

      template_body = if options[:partial]
                        path = File.split( options[:partial] )
                        path[-1] = "_#{path[-1]}"
                        path[-1] << TEMPLATE_FILE_EXTENSION unless path[-1].end_with?( TEMPLATE_FILE_EXTENSION )
                        file = File.join( path )
                        File.read( file )

                      elsif options[:template]
                        file = options[:template] 
                        file = file + TEMPLATE_FILE_EXTENSION unless file.end_with?( TEMPLATE_FILE_EXTENSION )
                        File.read( file )

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
