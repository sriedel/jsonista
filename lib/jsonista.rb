require 'json'

module Jsonista
  class SerializationError < StandardError ; end
end

require_relative 'jsonista/execution_environment'
require_relative 'jsonista/builder'
require_relative 'jsonista/compiler'
