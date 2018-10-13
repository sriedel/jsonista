module Jsonista
  class Compiler
    attr_reader :template_body

    def initialize(template_body)
      @template_body = template_body
    end

    def compile
      ExecutionEnvironment.get.eval(@template_body)
    end
  end
end
