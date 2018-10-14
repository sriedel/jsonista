require 'test_helper'

class Jsonista::Cache::InMemoryTest < Minitest::Spec
  describe 'the initializer' do
    describe 'when no initial state was passed' do
      subject { Jsonista::Cache::InMemory.new }

      it 'sets the cache to an empty hash' do
        subject.cache.must_equal( {} )
      end
    end

    describe 'when an initial state was passed' do
      let(:initial_state) { { :x => 1 } }
      subject { Jsonista::Cache::InMemory.new( initial_state ) }

      it 'sets the cache to the initial state' do
        subject.cache.must_equal( initial_state )
      end
    end
  end

  describe '#fetch' do
    let(:cache_key) { "my cache key" }
    subject { Jsonista::Cache::InMemory.new( initial_state ) }

    describe 'when the key has a value associated with it' do
      let(:initial_state) { { cache_key => cached_value } }

      describe 'that is not nil' do
        let(:cached_value) { "foo" }

        it 'should return the value' do
          subject.fetch( cache_key ).must_equal( cached_value ) 
        end
      end

      describe 'that is nil' do
        let(:cached_value) { nil }

        it 'should return nil' do
          subject.fetch( cache_key ).must_be_nil
        end
      end
    end

    describe "when the key has no value associated with it" do
      let(:initial_state) { {} }

      describe "and no value assignment block is passed" do
        it 'raises an execption' do
          lambda do
            subject.fetch( 'i_dont_exist' )
          end.must_raise( Jsonista::Cache::UnknownKey )
        end
      end

      describe "and a value assignment block is passed" do
        let(:cached_value) { "my cached value" }
        let(:value_assignment_block) do
          lambda { cached_value }
        end
        it 'stores the result of the value assignment block' do
          subject.fetch( cache_key, &value_assignment_block )
          subject.fetch( cache_key ).must_equal( cached_value )
        end

        it 'returns the result of the value assignment block' do
          subject.fetch( cache_key, &value_assignment_block ).must_equal( cached_value )
        end
      end
    end
  end

  describe '#store' do
    subject { Jsonista::Cache::InMemory.new( initial_state ) }

    let(:cache_key) { "my cache key" }
    let(:cached_value) { "my cached value" }

    describe 'when the key has no value assigned to it' do
      let(:initial_state) { {} }
      it 'should store the value' do
        subject.store( cache_key, cached_value )
        subject.fetch( cache_key ).must_equal( cached_value )
      end
    end

    describe 'when the key already has a value assigned to it' do
      let(:existing_value) { "existing cached value" }
      let(:initial_state) { { cache_key => existing_value } }

      it 'should overwrite the currently present value' do
        subject.store( cache_key, cached_value )
        subject.fetch( cache_key ).must_equal( cached_value )
      end
    end
  end

  describe '#invalidate' do
    let(:initial_state) do
      { :x => 1,
        :y => 2,
        :z => 3 }
    end
    subject { Jsonista::Cache::InMemory.new( initial_state ) }

    describe 'when called on a non-existing key' do
      it 'should not change the cache' do
        cache_before = subject.cache.dup
        subject.invalidate( :a )
        subject.cache.must_equal( cache_before )
      end
    end

    describe 'when called on an existing key' do
      it 'should remove the key from the cache' do
        subject.invalidate( :x )
        subject.cache.keys.wont_include( :x )
      end
    end

    describe 'when called for multiple keys' do
      it 'should remove each key' do
        cache_before = subject.cache.dup
        subject.invalidate( :x, :y )
        subject.cache.keys.wont_include( :x )
        subject.cache.keys.wont_include( :y )
        subject.cache[:z].must_equal( cache_before[:z] )
      end
    end
  end

  describe '#clear!' do
    let(:initial_state) do
      { :x => 1,
        :y => 2,
        :z => 3 }
    end
    subject { Jsonista::Cache::InMemory.new( initial_state ) }

    it 'flushes the entire cache' do
      subject.clear!
      subject.cache.must_equal( {} )
    end
  end
end
