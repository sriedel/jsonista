module Jsonista
  module Render
    def render( *args )
      options = args.pop if args.dig(-1).is_a?( Hash )
      options ||= {}
      file = args[0]

      template_body = if options[:partial]
                        if file
                          warn "Both file (#{file.inspect}) and partial (#{options[:partial].inspect}) given, proceeding with file"
                        else
                          path = File.split( options[:partial] )
                          path[-1] = "_#{path[-1]}"
                          path[-1] << ".jsonista" unless path[-1].end_with?( ".jsonista" )
                          file = File.join( path )
                        end
                        File.read( file )

                      elsif options[:template]
                        if file
                          warn "Both file (#{file.inspect}) and template (#{options[:template].inspect}) given, proceeding with file"
                        else
                          file = options[:template] 
                          file << ".jsonista" unless file.end_with?( ".jsonista" )
                        end
                        File.read( file )

                      elsif options[:string]
                        if file
                          warn "Both file (#{file.inspect}) and template string given, proceeding with file"
                          File.read(file)
                        else
                          options[:string]
                        end

                      else
                        if file
                          File.read( file )
                        else
                          raise NoTemplateError.new( "Must give either a filename as first parameter, or a :partial, :template or :string option" )
                        end
                      end
      Builder.new( template_body ).build
    end
    module_function :render
  end
end
