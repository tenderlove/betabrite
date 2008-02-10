$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
$:.unshift File.join(File.dirname(__FILE__), "..", "test")

require 'test/unit'
require 'betabrite'

class SetStringTest < Test::Unit::TestCase
  def setup
    @sign = BetaBrite::Base.new
    @sign.sleep_time = 0
  end

  def test_many_mem
    final =
[
0x00,0x00,0x00,0x00,0x00,0x01,0x5a,0x30,0x30,0x02,0x47,0x30,0x31,0x31,0x30,0x34,
0x35,0x2e,0x32,0x38,0x20,0x03,0x02,0x47,0x31,0x32,0x2e,0x34,0x31,0x20,0x03,0x02,
0x47,0x32,0x31,0x39,0x2e,0x39,0x32,0x20,0x03,0x02,0x47,0x33,0x31,0x36,0x2e,0x35,
0x36,0x20,0x03,0x02,0x47,0x34,0x33,0x2e,0x33,0x37,0x20,0x03,0x02,0x47,0x35,0x31,
0x36,0x2e,0x34,0x37,0x20,0x03,0x04
]
    final_s = final.collect { |x| x.chr }.join
    [ 
      '11045.28 ',
      '2.41 ',
      '19.92 ',
      '16.56 ',
      '3.37 ',
      '16.47 '
    ].each_with_index do |price,idx|
      @sign.string_files << BetaBrite::Files::String.new(idx, price)
    end

    assert_equal('11045.28 ', @sign.string_files[0].message)
    assert_equal(0, @sign.string_files[0].label)
    assert_equal('2.41 ', @sign.string_files[1].message)
    assert_equal(1, @sign.string_files[1].label)
    assert_equal('19.92 ', @sign.string_files[2].message)
    assert_equal(2, @sign.string_files[2].label)
    assert_equal('16.56 ', @sign.string_files[3].message)
    assert_equal(3, @sign.string_files[3].label)
    assert_equal('3.37 ', @sign.string_files[4].message)
    assert_equal(4, @sign.string_files[4].label)
    assert_equal('16.47 ', @sign.string_files[5].message)
    assert_equal(5, @sign.string_files[5].label)

    assert_equal(6, @sign.string_files.length)
    assert_equal(0, @sign.text_files.length)
    assert_equal(0, @sign.dots_files.length)

    printed = @sign.message
    assert_equal(final_s, printed)
  end
end
