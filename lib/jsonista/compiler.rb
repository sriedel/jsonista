module Jsonista
  class Compiler
    attr_reader :template_body

    def initialize( template_body, file_name = nil )
      @template_body = template_body
      @file_name = file_name
    end

    def compile( local_variable_hash = nil )
      ExecutionEnvironment.get( local_variable_hash ).eval( @template_body, @file_name || "(unknown)" )
    end
  end
end
