require 'test_helper'

class Jsonista::ExecutionEnvironmentTest < Minitest::Test
  describe '.get' do
    let(:result) { Jsonista::ExecutionEnvironment.get }

    it "returns an instance of Binding" do
      result.must_be_kind_of(Binding)
    end

    it "has no local variables defined" do
      result.local_variables.must_be_empty
    end
  end
end
