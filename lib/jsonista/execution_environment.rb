module Jsonista
  class ExecutionEnvironment
    def self.get
      Proc.new{}.binding
    end
  end
end
