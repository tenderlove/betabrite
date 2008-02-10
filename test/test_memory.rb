$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
$:.unshift File.join(File.dirname(__FILE__), "..", "test")

require 'test/unit'
require 'betabrite'

class MemoryAllocTest < Test::Unit::TestCase
  def setup
    @sign = BetaBrite::Base.new
    @sign.sleep_time = 0
  end

  def test_text_file
    alloc_string = [ 0, 0, 0, 0, 0, 1, 90, 48, 48, 2, 69, 36, 65, 65, 85, 48, 49, 48, 48, 70, 70, 48, 48, 4 ]
    string = alloc_string.collect { |x| x.chr }.join
    mem = BetaBrite::Memory::Text.new('A', 256)

    @sign.memory << mem
    test_string = @sign.memory_message

    assert_equal(string, test_string)
  end

  def test_string_file
    alloc_string = [ 0, 0, 0, 0, 0, 1, 90, 48, 48, 2, 69, 36, 48, 66, 76, 48, 48, 50, 48, 48, 48, 48, 48, 4 ]
    string = alloc_string.collect { |x| x.chr }.join
    mem = BetaBrite::Memory::String.new('0', 32)

    @sign.memory << mem
    test_string = @sign.memory_message

    assert_equal(string, test_string)
  end

  def test_dots_file
    alloc_string = [ 0, 0, 0, 0, 0, 1, 90, 48, 48, 2, 69, 36, 49, 68, 85, 48, 55, 48, 55, 52, 48, 48, 48, 4 ]
    string = alloc_string.collect { |x| x.chr }.join
    mem = BetaBrite::Memory::Dots.new('1', 7, 7)

    @sign.memory << mem
    test_string = @sign.memory_message

    assert_equal(string, test_string)
  end

  def test_string_text_file
    alloc_string = [ 0, 0, 0, 0, 0, 1, 90, 48, 48, 2, 69, 36, 48, 66, 76, 48, 48, 50, 48, 48, 48, 48, 48, 65, 65, 85, 48, 49, 48, 48, 70, 70, 48, 48, 4 ]
    string = alloc_string.collect { |x| x.chr }.join
    mem = BetaBrite::Memory::String.new('0', 32)
    text = BetaBrite::Memory::Text.new('A', 256)

    @sign.memory << mem
    @sign.memory << text

    test_string = @sign.memory_message
    assert_equal(string, test_string)
  end
end
