require 'test_helper'
require 'minitest/autorun'

class Jsonista::BuilderTest < Minitest::Spec
  let(:template_body) { '12.3' }
  subject { Jsonista::Builder.new( template_body ) }

  describe 'the initializer' do
    it 'sets the template_body' do
      subject.template_body.must_equal( template_body )
    end

    describe 'when no serialized_string is given' do 
      subject { Jsonista::Builder.new( template_body ) }

      it 'sets serialized_string to an empty string' do
        subject.serialized_string.must_equal( '' )
      end
    end

    describe 'when a serialized_string is given' do
      let(:serialized_string) { 'foo' }
      subject { Jsonista::Builder.new( template_body, serialized_string ) }

      it 'should set the serialized string to the given string' do
        subject.serialized_string.object_id.must_equal( serialized_string.object_id )
      end
    end
  end

  describe '#build' do
    describe 'when the template contained nil' do
      let(:template_value) { nil }
      let(:template_body)  { "#{template_value.inspect}" }

      it 'should return a json nil' do
        subject.build.must_equal( template_value.to_json )
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

  end
end
