require 'test_helper'
require 'minitest/autorun'

class Jsonista::BuilderTest < Minitest::Spec
  subject { Jsonista::Builder.new }

  describe 'the initializer' do
    it 'sets string to an empty string' do
      subject.string.must_equal('')
    end
  end
end
