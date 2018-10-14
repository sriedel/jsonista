JSONISTA_BINDING = Object.new.instance_eval do
                     def render
                       "Render partial called"
                     end

                     def cache
                     end
                     binding
                   end

module Jsonista
  class ExecutionEnvironment
    def self.get
      JSONISTA_BINDING.dup
    end
  end
end
