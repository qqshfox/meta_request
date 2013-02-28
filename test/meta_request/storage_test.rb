require 'test_helper'

describe MetaRequest::Storage do
  describe 'write' do
    it 'writes to file' do
      MetaRequest::Storage.new('1234').write('abcdef')
      assert_equal 'abcdef', MetaRequest::Storage.tempfiles['1234.json'].tap(&:rewind).read
    end
  end

  describe 'read' do
    it 'reads from file' do
      MetaRequest::Storage.tempfiles['foo.json'].tap(&:rewind).write('bar')
      assert_equal 'bar', MetaRequest::Storage.new('foo').read
    end
  end

  after do
    MetaRequest::Storage.clean
  end
end
