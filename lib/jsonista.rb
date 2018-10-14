require 'json'

module Jsonista
  class SerializationError < StandardError ; end
  class NoTemplateError < StandardError ; end

  def self.render( *args )
    structure = Render.render( *args )
    Serializer.new.serialize( structure )
  end
end

require_relative 'jsonista/execution_environment'
require_relative 'jsonista/serializer'
require_relative 'jsonista/compiler'
require_relative 'jsonista/render'
require_relative 'jsonista/cache'
require_relative 'jsonista/cache_placeholder'
