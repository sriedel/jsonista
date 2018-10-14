require 'test_helper'

class Jsonista::CachedValueTest  < Minitest::Spec
  let(:key) { "my key" }
  let(:cache_miss_block) do
    lambda { "x" }
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
end
