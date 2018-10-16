require 'test_helper'

class Jsonista::Cache::NullTest < Minitest::Spec
  subject { Jsonista::Cache::Null.new }

  describe 'the initializer' do
    it 'sets the cache to nil' do
      subject.cache.must_be_nil
    end
  end

  describe '#fetch' do
    let(:cache_key) { "my cache key" }

    describe "when no value assignment block is passed" do
      it 'raises an execption' do
        lambda do
          subject.fetch( 'i_dont_exist' )
        end.must_raise( Jsonista::Cache::UnknownKey )
      end
    end

    describe "and a value assignment block is passed" do
      let(:cache_key) { "my cache key" }
      let(:cached_value) { "my cached value" }
      let(:value_assignment_block) do
        lambda { cached_value }
      end

      it 'returns the result of the value assignment block' do
        subject.fetch( cache_key, &value_assignment_block ).must_equal( cached_value )
      end
    end
  end

  describe '#store' do
    let(:cache_key) { "my cache key" }
    let(:cached_value) { "my cached value" }

    it 'does not raise an exception when called' do
      subject.store( cache_key, cached_value )
    end
  end

  describe '#invalidate' do
    it 'does not raise an exception when called' do
      subject.invalidate( :key1, :key2 )
    end
  end

  describe '#clear!' do
    it 'does not raise an exception when called' do
      subject.clear!
    end
  end
end
