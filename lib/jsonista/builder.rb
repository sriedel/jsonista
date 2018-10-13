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
        when Numeric, String, Symbol
          @serialized_string << structure.to_json

        when Array
          @serialized_string << "["
          structure.each do |substructure|
            serialize(substructure)
            @serialized_string << ","
          end
          @serialized_string.chop! unless structure.empty?
          @serialized_string << "]"

        when Hash
          @serialized_string << "{"
          structure.each_pair do |key, substructure|
            @serialized_string << key.to_s.to_json << ":"
            serialize(substructure)
            @serialized_string << ","
          end
          @serialized_string.chop! unless structure.empty?
          @serialized_string << "}"
        
        else
          raise SerializationError.new( "Don't know how to serialize an object of type #{structure.class} (context: #{@serialized_string[-200,200]}" )
      end

      @serialized_string
    end
  end
end
