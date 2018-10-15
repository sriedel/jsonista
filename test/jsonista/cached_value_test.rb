require 'test_helper'

class Jsonista::CachedValueTest  < Minitest::Spec
  let(:key) { "my key" }
  let(:new_cache_value) { "my new cache value" }
  let(:cache_miss_block) do
    lambda { new_cache_value }
  end

  subject { Jsonista::CachedValue.new( key, &cache_miss_block ) }

  describe 'the initializer' do
    it 'sets the key' do
      subject.key.must_equal( key )
    end

    it 'sets the cache_miss_block' do
      subject.cache_miss_block.must_equal( cache_miss_block )
    end
  end

  describe '#resolve' do
    let(:cache) { Jsonista::Cache::InMemory.new( initial_cache_state ) }

    before( :each ) do
      Jsonista.cache = cache
    end

    after( :each ) do
      Jsonista.cache = nil
    end

    describe 'when the key is present in the cache' do
      let(:cached_value) { "my cached value" }
      let(:initial_cache_state) do
        { key => cached_value }
      end

      it 'returns the cached value' do
        subject.resolve.must_equal( cached_value )
      end
    end

    describe 'when the key is not present in the cache' do
      let(:initial_cache_state) { {} }

      describe 'and no cache_miss_block was given' do
        let(:cache_miss_block) { nil }

        it 'raises an exception' do
          lambda do
            subject.resolve
          end.must_raise( Jsonista::Cache::UnknownKey )
        end
      end

      describe 'and a cache_miss_block was given' do
        let(:new_cache_value) { "my new value" }
        let(:cache_miss_block) do
          lambda { new_cache_value }
        end

        it 'returns the new cached value' do
          subject.resolve.must_equal( new_cache_value.to_json )
        end

        it 'stores the new value in the cache' do
          subject.resolve
          cache.fetch( key ).must_equal( new_cache_value.to_json )
        end

        describe 'when the variable values change' do
          let(:template) do
            <<~EOF
              [ "first value", "second value" ].each_with_index.map do |value, index|
                cache( "key_\#{index}" ) do
                  value
                end
              end
            EOF
          end

          it 'will execute with its proper binding in a changing environment' do
            rendering_result = Jsonista.render( :string => template )
            rendering_result.must_equal( %{["first value","second value"]} )
          end

          it 'will store the results in the cache' do
            Jsonista.render( :string => template )

            cache.fetch( 'key_0' ).must_equal( %{"first value"} )
            cache.fetch( 'key_1' ).must_equal( %{"second value"} )
          end
        end
      end
    end
  end
end
