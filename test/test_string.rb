$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
$:.unshift File.join(File.dirname(__FILE__), "..", "test")

require 'test/unit'
require 'betabrite'

class StringTest < Test::Unit::TestCase
  def test_const_dsl
    s = BetaBrite::String.new("hello") { |a|
      a.green
      a.five_high
    }

    assert_equal(BetaBrite::String::Color::GREEN, s.color)
    assert_equal(BetaBrite::String::CharSet::FIVE_HIGH, s.charset)
    assert_equal("hello", s.string)
  end

  def test_parse
    string1 = BetaBrite::String.new('foo').green
    string2 = BetaBrite::String.new('foo').rgb('FF00FF')
    string = "#{string1.to_s}#{string2.to_s}"

    parsed = BetaBrite::String.parse(string)
    assert_equal(2, parsed.length)
    assert parsed.all? { |x| x.is_a?(BetaBrite::String) }
  end
end

