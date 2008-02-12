require File.expand_path(File.join(File.dirname(__FILE__), "helper"))

class USBBetaBriteTest < Test::Unit::TestCase
  def test_stringfile
    bb = BetaBrite::USB.new do |sign|
      sign.stringfile('0') do
        print "hello ALIVE!!!"
      end
    end
    assert_equal 1, bb.string_files.length
    assert_equal 'hello ALIVE!!!', bb.string_files.first.message
  end

  def test_write_message
    bb = BetaBrite::USB.new do |sign|
      sign.textfile do
        print "hello ALIVE!!!"
      end
    end
    assert_equal "hello ALIVE!!!", bb.text_files.first.message
    assert bb.message
  end

  def test_allot_dots
    alloc_string = [ 0, 0, 0, 0, 0, 1, 90, 48, 48, 2, 69, 36, 49, 68, 85, 48, 55, 48, 55, 52, 48, 48, 48, 4 ]
    bb = BetaBrite::USB.new do |sign|
      sign.allocate do |memory|
        memory.dots('1', 7, 7)
      end
    end
    assert_equal(1, bb.memory.length)
    assert_equal(alloc_string.pack('C*'), bb.memory_message)
  end

  def test_allocate_string
    message = [ 0, 0, 0, 0, 0, 1, 90, 48, 48, 2, 69, 36, 65, 65, 85, 48, 49, 48, 48, 70, 70, 48, 48, 4 ]
    bb = BetaBrite::USB.new do |sign|
      sign.allocate do |memory|
        memory.text('A', 256)
      end
    end

    assert_equal(1, bb.memory.length)
    assert bb.memory_message
    msg_u = bb.memory_message.unpack('C*')
    assert_equal(message.pack('C*'), bb.memory_message)
  end

  def test_multi_alloc
    final = 
[
0x00,0x00,0x00,0x00,0x00,0x01,0x5a,0x30,0x30,0x02,0x45,0x24,0x41,0x41,0x55,0x31,
0x30,0x30,0x30,0x46,0x46,0x30,0x30,0x30,0x42,0x4c,0x30,0x30,0x34,0x30,0x30,0x30,
0x30,0x30,0x31,0x42,0x4c,0x30,0x30,0x34,0x30,0x30,0x30,0x30,0x30,0x32,0x42,0x4c,
0x30,0x30,0x34,0x30,0x30,0x30,0x30,0x30,0x33,0x42,0x4c,0x30,0x30,0x34,0x30,0x30,
0x30,0x30,0x30,0x34,0x42,0x4c,0x30,0x30,0x34,0x30,0x30,0x30,0x30,0x30,0x35,0x42,
0x4c,0x30,0x30,0x34,0x30,0x30,0x30,0x30,0x30,0x36,0x42,0x4c,0x30,0x30,0x34,0x30,
0x30,0x30,0x30,0x30,0x37,0x42,0x4c,0x30,0x30,0x34,0x30,0x30,0x30,0x30,0x30,0x38,
0x42,0x4c,0x30,0x30,0x34,0x30,0x30,0x30,0x30,0x30,0x39,0x42,0x4c,0x30,0x30,0x34,
0x30,0x30,0x30,0x30,0x30,0x04
]
    bb = BetaBrite::USB.new do |sign|
      sign.allocate do |memory|
        memory.text('A', 4096)
        0.upto(9) do |x|
          memory.string(x.to_s, 64)
        end
      end
    end

    assert_equal(11, bb.memory.length)
    assert bb.memory_message
    msg_u = bb.memory_message.unpack('C*')
    assert_equal(final.pack('C*'), bb.memory_message)
  end

  def test_write_red_green_message
    bb = BetaBrite::USB.new do |sign|
      sign.textfile do
        print string("hello ").red
        print string("wo").green
        print string("rld").rgb('3399FF')
      end
    end
    assert_equal(1, bb.text_files.length)
    assert bb.message
  end

  #def test_clear_memory
  #  BetaBrite::USB.new do |sign|
  #    sign.clear_memory!
  #  end
  #end
end
