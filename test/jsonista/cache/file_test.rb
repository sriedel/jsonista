require 'test_helper'

class Jsonista::Cache::FileTest < Minitest::Spec
  let(:cache_root) { "tmp/cache/jsonista" }
  let(:cache_file) { File.join( cache_root, cache_key ) }

  before(:each) do
    FileUtils.mkdir_p( cache_root )
  end

  subject { Jsonista::Cache::File.new( cache_root ) }

  describe 'the initializer' do
    describe 'when no cache root dir was passed' do
      subject { Jsonista::Cache::File.new }

      it 'sets the cache to an empty hash' do
        subject.cache_root_path.must_equal( File.join( Dir.pwd, 'jsonista_cache' ) )
      end
    end

    describe 'when a cache root dir was passed' do
      it 'sets the cache root dir to the given path' do
        subject.cache_root_path.must_equal( cache_root )
      end
    end
  end

  describe '#fetch' do
    let(:cache_key) { "my_cache_key" }

    describe 'when the key has a file associated with it' do
      let(:cached_value) { "foo" }

      before(:each) do
        File.write( cache_file, cached_value )
      end

      it 'should return the value' do
        subject.fetch( cache_key ).must_equal( cached_value ) 
      end
    end

    describe "when the key has no file associated with it" do
      before(:each) do
        File.unlink( cache_file ) if File.exist?( cache_file )
      end

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
          File.read( cache_file ).must_equal( cached_value )
        end

        it 'returns the result of the value assignment block' do
          subject.fetch( cache_key, &value_assignment_block ).must_equal( cached_value )
        end
      end
    end
  end

  describe '#store' do
    let(:cache_key) { "my cache key" }
    let(:cached_value) { "my cached value" }

    describe 'when the key has no file assigned to it' do
      before( :each ) do
        File.unlink( cache_file ) if File.exist?( cache_file )
      end

      it 'should store the value' do
        subject.store( cache_key, cached_value )
        subject.fetch( cache_key ).must_equal( cached_value )
        File.read( cache_file ).must_equal( cached_value )
      end
    end

    describe 'when the key already has a file assigned to it' do
      let(:existing_value) { "existing cached value" }

      before(:each ) do
        File.write( cache_file, existing_value )
      end

      it 'should overwrite the currently present value' do
        subject.store( cache_key, cached_value )
        subject.fetch( cache_key ).must_equal( cached_value )
        File.read( cache_file ).must_equal( cached_value )
      end
    end
  end

  describe '#invalidate' do
    let(:cache_key) { "my cache key" }

    describe 'when called on a key without a file' do
      before(:each) do
        File.unlink( cache_file ) if File.exist?( cache_file )
      end

      it 'should not raise an exception' do
        subject.invalidate( cache_key )
      end
    end

    describe 'when called on a key with an existing file' do
      let(:cached_value) { "my cached value" }

      before(:each) do
        File.write( cache_file, cached_value )
      end

      it 'should delete the file from the cache' do
        subject.invalidate( cache_key )
        File.exist?( cache_file ).must_equal( false )
      end

      it 'should not have a value associated with it' do
        subject.invalidate( cache_key )
        subject.fetch( cache_key ) do
          "block called"
        end.must_equal( "block called" )
      end
    end

    describe 'when called for multiple keys' do
      let(:cache_key_x) { "x" }
      let(:cache_key_y) { "y" }
      let(:cache_key_z) { "z" }
      let(:cache_file_x) { File.join( cache_root, cache_key_x ) }
      let(:cache_file_y) { File.join( cache_root, cache_key_y ) }
      let(:cache_file_z) { File.join( cache_root, cache_key_z ) }
      let(:cached_value_x) { cache_key_x }
      let(:cached_value_y) { cache_key_y }
      let(:cached_value_z) { cache_key_z }

      before(:each) do
        File.write( cache_file_x, cached_value_x )
        File.write( cache_file_y, cached_value_y )
        File.write( cache_file_z, cached_value_z )
      end

      it 'should remove each file' do
        subject.invalidate( :x, :y )
        File.exist?( cache_file_x ).must_equal( false )
        File.exist?( cache_file_y ).must_equal( false )
        File.exist?( cache_file_z ).must_equal( true )
        subject.fetch( cache_key_z ).must_equal( cached_value_z )
      end
    end
  end

  describe '#clear!' do
    before(:each) do
      File.write( File.join( cache_root, "some_file" ), "" )
      FileUtils.mkdir_p( File.join( cache_root, "subdir" ) )
      File.write( File.join( cache_root, "subdir", "some_other_file" ), "" )
    end
    

    it 'deletes all files in the cache_root dir' do
      subject.clear!
      Dir.children( cache_root ).must_equal( [] )
    end
  end
end
