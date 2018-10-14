require 'test_helper'
require 'minitest/autorun'

class Jsonista::SerializerTest < Minitest::Spec
  subject { Jsonista::Serializer.new }

  describe 'the initializer' do
    describe 'when no serialized_string is given' do 
      subject { Jsonista::Serializer.new }

      it 'sets serialized_string to an empty string' do
        subject.serialized_string.must_equal( '' )
      end
    end

    describe 'when a serialized_string is given' do
      let(:serialized_string) { 'foo' }
      subject { Jsonista::Serializer.new( serialized_string ) }

      it 'should set the serialized string to the given string' do
        subject.serialized_string.object_id.must_equal( serialized_string.object_id )
      end
    end
  end

  describe "#serialize" do
    let(:result) { subject.serialize( structure ) }

    describe "when passed nil" do
      let(:structure) { nil }

      it 'returns "null"' do
        result.must_equal( "null" )
      end
    end

    describe "when passed true" do
      let(:structure) { true }

      it 'returns "true"' do
        result.must_equal( "true" )
      end
    end

    describe "when passed false" do
      let(:structure) { false }

      it 'returns "false"' do
        result.must_equal( "false" )
      end
    end

    describe "when passed an integer" do
      let(:structure) { 1 }

      it 'returns the serialized integer' do
        result.must_equal( "1" )
      end
    end
    
    describe "when passed a negative integer" do
      let(:structure) { -1 }

      it 'returns the serialized integer' do
        result.must_equal( "-1" )
      end
    end
    
    describe "when passed a floating point number" do
      let(:structure) { 1.23 }

      it 'returns the serialized floating point number' do
        result.must_equal( "1.23" )
      end
    end
    
    describe "when passed a negative floating point number" do
      let(:structure) { -3.21 }

      it 'returns the serialized floating point number' do
        result.must_equal( "-3.21" )
      end
    end

    describe "when passed a blank string" do
      let(:structure) { '' }

      it 'returns the serialized string' do
        result.must_equal( '""' )
      end
    end

    describe "when passed a string" do
      let(:structure) { 'foo bar' }

      it 'returns the serialized string' do
        result.must_equal( '"foo bar"' )
      end
    end

    describe "when passed a symbol" do
      let(:structure) { :foo }

      it 'resutns the serialized string representation of the symbol' do
        result.must_equal( '"foo"' )
      end
    end

    describe "when passed an empty array" do
      let(:structure) { [] }

      it 'returns the serialized array' do
        result.must_equal( '[]' )
      end
    end

    describe "when passed an array with content" do
      let(:structure) { [ 1, 2, 3 ] }

      it 'returns the serialized array' do
        result.must_equal( '[1,2,3]' )
      end
    end

    describe "when passed an empty hash" do
      let(:structure) { {} }

      it 'returns the serialized hash' do
        result.must_equal( '{}' )
      end
    end

    describe "when passed a hash with content" do
      let(:structure) do
        { "x" => 1, "y" => 2 }
      end

      it 'returns the serialized array' do
        result.must_equal( '{"x":1,"y":2}' )
      end
    end

    describe "when passed a Jsonista::CachedValue" do
      let(:cache_key) { "my cache key" }
      let(:cache_miss_block) do
        lambda { "x" }
      end
      let(:structure) { Jsonista::CachedValue.new( cache_key, &cache_miss_block ) }

      it 'returns the resolved cache value' do
        result.must_equal( '"this value is cached"' )
      end
    end

    describe "when passed a nested structure" do
      let(:structure) do
        { :null              => nil,
          "true"             => true,
          "false"            => false,
          :integer           => 1,
          :array_of_integers => [ 1, 2, 3 ],
          :array_of_strings  => %w[ foo bar baz ],
          :array_of_hashes   => [ { :x => 1 }, { :x => 2 } ],
          :subhash           => { :foo => :bar } }
      end
      let(:expected_result) do
        %|{"null":null,"true":true,"false":false,"integer":1,"array_of_integers":[1,2,3],"array_of_strings":["foo","bar","baz"],"array_of_hashes":[{"x":1},{"x":2}],"subhash":{"foo":"bar"}}|
      end

      it 'returns the expected serialization' do
        result.must_equal( expected_result )
      end
    end

    describe "when passed an unknown object" do
      let(:structure) { Object.new }

      it 'raises an error' do
        lambda { result }.must_raise( Jsonista::SerializationError )
      end
    end
  end
end
