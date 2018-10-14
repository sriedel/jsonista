require 'json'

module Jsonista
  class SerializationError < StandardError ; end
  class NoTemplateError < StandardError ; end
end

require_relative 'jsonista/execution_environment'
require_relative 'jsonista/serializer'
require_relative 'jsonista/compiler'
require_relative 'jsonista/render'
