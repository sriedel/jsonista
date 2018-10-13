JSONISTA_BINDING = Object.new.instance_eval do
                     def render_partial
                       "Render partial called"
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
