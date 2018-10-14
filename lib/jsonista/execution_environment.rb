require 'byebug'

module Jsonista
  class ExecutionEnvironment
    def self.get( local_variable_hash = nil )
      @environment ||= build_new_environment
      environment = @environment.dup

      if local_variable_hash
        local_variable_hash.each_pair do |name, value|
          environment.local_variable_set( name, value )
        end
      end

      environment
    end
  end
end

Jsonista::ExecutionEnvironment.class_eval do
  def self.build_new_environment
    Object.allocate.instance_eval do
      class << self
        include Jsonista::DSL::Render
        include Jsonista::DSL::Cache
      end

      binding
    end
  end
end
