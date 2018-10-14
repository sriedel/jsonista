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

    it "must have a cache top level function" do
      result.eval("cache('key')")
    end

    describe "when a hash of local variables to set is passed" do
      let(:result) { Jsonista::ExecutionEnvironment.get( local_variables ) }
      let(:local_variables) do
        { :x => 1,
          :y => 2 }
      end

      it "sets the variables" do
        result.local_variables.sort.must_equal( local_variables.keys.sort )
      end

      it "has the variables set up with the given values" do
        result.eval( "x" ).must_equal( local_variables[:x] )
        result.eval( "y" ).must_equal( local_variables[:y] )
      end
    end
  end
end
