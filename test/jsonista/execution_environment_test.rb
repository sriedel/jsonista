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

    it "always returns different instances" do
      result.wont_equal( Jsonista::ExecutionEnvironment.get )
    end

    it "is not nested in a module" do
      result.eval("Module.nesting").must_equal( [] )
    end

    it "must have a render top level function" do
      result.eval("render")
    rescue Jsonista::NoTemplateError
      # if this is raised, the method was called
      true
    end

    it "must has a cache top level function" do
      result.eval("public_methods").must_include( :cache )
    end
  end
end
