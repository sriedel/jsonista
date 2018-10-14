require 'json'

module Jsonista
  class SerializationError < StandardError ; end
  class NoTemplateError < StandardError ; end

  def self.render( *args )
    structure = DSL::Render.render( *args )
    Serializer.new.serialize( structure )
  end
end

require_relative 'jsonista/execution_environment'
require_relative 'jsonista/serializer'
require_relative 'jsonista/compiler'
require_relative 'jsonista/cached_value'
require_relative 'jsonista/dsl/render'
require_relative 'jsonista/dsl/cache'
