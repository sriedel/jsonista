module Jsonista
  class Serializer
    attr_reader :serialized_string

    def initialize( serialized_string = '' )
      @serialized_string = serialized_string
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

        when Jsonista::CachePlaceholder
          @serialized_string << structure.resolve.to_json
        
        else
          raise SerializationError.new( "Don't know how to serialize an object of type #{structure.class} (context: #{@serialized_string[-200,200]}" )
      end

      @serialized_string
    end
  end
end
