module Jsonista
  class ExecutionEnvironment
    def self.get
      Object.new.instance_eval do
        def render_partial
          "Render partial called"
        end
        binding
      end
    end
  end
end
