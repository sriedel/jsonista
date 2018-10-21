require 'json'
require 'fileutils'

module Jsonista
  class SerializationError < StandardError ; end
  class NoTemplateError < StandardError ; end

  def self.render( *args )
    structure = DSL::Render.render( *args )
    Serializer.new.serialize( structure )
  end

  def self.cache=( cache )
    @cache = cache
  end

  def self.cache
    @cache
  end

  def self.helpers=( array_of_modules )
    @helpers = array_of_modules
    Jsonista::ExecutionEnvironment.clear!
    @helpers
  end

  def self.helpers
    @helpers ||= []
  end
end

require_relative 'jsonista/execution_environment'
require_relative 'jsonista/serializer'
require_relative 'jsonista/compiler'
require_relative 'jsonista/cached_value'
require_relative 'jsonista/dsl/render'
require_relative 'jsonista/dsl/cache'
require_relative 'jsonista/cache'
require_relative 'jsonista/cache/null'
require_relative 'jsonista/cache/in_memory'
require_relative 'jsonista/cache/file'
