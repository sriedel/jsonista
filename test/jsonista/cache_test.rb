require 'test_helper'

class Jsonista::CacheTest < Minitest::Spec
  describe '.cache' do
    let(:key) { "my cache key" }
    let(:cache_miss_block) do
      lambda { x }
    end
    let(:result) { Jsonista::Cache.cache( key, &cache_miss_block ) }

    it 'returns a Jsonista::CachePlaceholder with the exepcted attributes' do
      result.must_be_kind_of( Jsonista::CachePlaceholder )
      result.key.must_equal( key )
      result.cache_miss_block.must_equal( cache_miss_block )
    end
  end
end
