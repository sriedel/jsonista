require 'test_helper'

class Jsonista::CompilerTest < Minitest::Spec
  let(:template_body) { '' }
  subject { Jsonista::Compiler.new( template_body ) }

  describe 'the initializer' do
    it 'sets the template body' do
      subject.template_body.must_equal( template_body )
    end
  end

  describe '#compile' do
    let(:template_body) { "#{template_value.inspect}" }

    describe 'when the template contains a string value' do
      let(:template_value) { 'foo' }

      it 'returns the evaluated scalar value' do
        subject.compile.must_equal( template_value )
      end
    end

    describe 'when the template contains a numeric value' do
      let(:template_value) { 12.3 }

      it 'returns the evaluated scalar value' do
        subject.compile.must_equal( template_value )
      end
    end

    describe 'when the template contains a nil' do
      let(:template_body) { "nil" }

      it 'returns a nil' do
        subject.compile.must_be_nil
      end
    end

    describe 'when the template contains a true' do
      let(:template_body) { "true" }

      it 'returns a nil' do
        subject.compile.must_equal(true)
      end
    end

    describe 'when the template contains a false' do
      let(:template_body) { "false" }

      it 'returns a nil' do
        subject.compile.must_equal(false)
      end
    end

    describe 'when the template contains an array' do
      let(:template_value) { [1,2,3,4] }

      it 'returns the evaluated array value' do
        subject.compile.must_equal( template_value )
      end
    end

    describe 'when the template contains a hash' do
      let(:template_value) do
        { :x => 1, 
          :y => 'foo' }
      end

      it 'returns the evaluated hash value' do
        subject.compile.must_equal( template_value )
      end
    end

    describe 'when the template contains a nested structure' do
      let(:template_value) do
        { :x => [1,2,4], 
          :y => 'foo' }
      end

      it 'returns the evaluated hash value' do
        subject.compile.must_equal( template_value )
      end
    end

    describe 'when the template contains instructions to be evaluated' do
      let(:template_body) { '1 + 2' }

      it 'returns the evaluated value' do
        subject.compile.must_equal( 3 )
      end
    end

    describe 'when the template contains method invocations' do
      let(:template_body) { '[1].map { |x| x * 2 }' }

      it 'returns the evaluated value' do
        subject.compile.must_equal( [2] )
      end
    end
  end
end
