require 'byebug'

module Jsonista
  class ExecutionEnvironment
    def self.get
      @environment ||= build_new_environment
      @environment.dup
    end
  end
end

Jsonista::ExecutionEnvironment.class_eval do
  def self.build_new_environment
    Object.allocate.instance_eval do
      class << self
        include Jsonista::Render
      end

      def cache
      end
      binding
    end
  end
end
