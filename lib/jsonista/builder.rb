module Jsonista
  class Builder
    attr_reader :serialized_string, :template_body

    def initialize( template_body, serialized_string = '' )
      @template_body = template_body
      @serialized_string = serialized_string
    end

    def build
      compiler = Compiler.new( template_body )
      evaluated_structure = compiler.compile
      serialize(evaluated_structure)
    end

    def serialize(structure)
      case structure
        when nil   then @serialized_string << "null"
        when true  then @serialized_string << "true"
        when false then @serialized_string << "false"
        when Numeric, String then @serialized_string << structure.to_json
      end

      @serialized_string
    end
    
  end
end
