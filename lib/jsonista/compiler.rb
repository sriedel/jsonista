module Jsonista
  class Compiler
    attr_reader :template_body

    def initialize( template_body, file_name = nil )
      @template_body = template_body
      @file_name = file_name
    end

    def compile
      ExecutionEnvironment.get.eval( @template_body, @file_name || "(unknown)" )
    end
  end
end
