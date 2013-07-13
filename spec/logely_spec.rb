require 'stringio'
require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/logely'

class StringIO
  def must_equal(*args)
    rewind
    read.must_equal(*args)
  end
end

describe Logely do
  let(:output) { StringIO.new }

  describe 'once configured' do
    subject { Logely.new }

    it 'does not allow new actions to be added' do
      -> { subject.wrote :green }.must_raise NoMethodError
    end
  end

  describe 'setting padding' do
    subject do
      Logely.new output, padding: 4 do
        wrote
      end
    end

    it 'sets the left padding' do
      subject.wrote 'some/file.txt'
      output.must_equal "    wrote  some/file.txt\n"
    end
  end

  describe 'setting gutter' do
    subject do
      Logely.new output, gutter: 4 do
        wrote
      end
    end

    it 'sets the middle gutter' do
      subject.wrote 'some/file.txt'
      output.must_equal "  wrote    some/file.txt\n"
    end
  end

  describe 'a normal action' do
    subject do
      Logely.new output do
        wrote :green
        deleted
      end
    end

    it 'is defined' do
      subject.must_respond_to :wrote
    end

    it 'puts formatted message' do
      subject.wrote "some/file.txt"

      output.must_equal '    ' + 'wrote'.green + '  some/file.txt' + "\n"
    end
  end

  describe 'a waiting action' do
    subject do
      Logely.new output do
        checked?
        failed
      end
    end

    it 'is define' do
      subject.must_respond_to :checked
    end

    it 'prints a formatted message' do
      subject.checked 'some/file.txt'

      output.must_equal '  checked  some/file.txt'
    end

    it 'must be flushed to start a new line' do
      subject.checked 'some/file.txt'
      subject.flush

      output.must_equal '  checked  some/file.txt' + "\n"
    end

    it 'can be overwritten' do
      subject.checked 'some/file.txt'
      subject.failed! 'some/file.txt'

      output.must_equal "  checked  some/file.txt\r   failed  some/file.txt\n"
    end
  end

end
