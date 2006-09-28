$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
$:.unshift File.join(File.dirname(__FILE__), "..", "test")

require 'test/unit'
require 'betabrite'
require 'bb_override'

class StringTest < Test::Unit::TestCase
  def test_const_dsl
    s = BetaBrite::String.new("hello") { |a|
      a.set_color "green"
      a.set_charset "five_high"
    }

    assert_equal(BetaBrite::String::Color::GREEN, s.color)
    assert_equal(BetaBrite::String::CharSet::FIVE_HIGH, s.charset)
    assert_equal("hello", s.string)
  end
end

