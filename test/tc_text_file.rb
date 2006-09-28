$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
$:.unshift File.join(File.dirname(__FILE__), "..", "test")

require 'test/unit'
require 'betabrite'
require 'bb_override'

class TextFileTest < Test::Unit::TestCase
  def test_const_dsl
    tf = BetaBrite::TextFile.new { |a|
      a.set_mode "roll_down"
      a.set_position "middle"
    }

    assert_equal(BetaBrite::TextFile::Position::MIDDLE, tf.position)
    assert_equal(BetaBrite::TextFile::Mode::ROLL_DOWN, tf.mode)
  end
end
