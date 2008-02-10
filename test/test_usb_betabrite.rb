require File.expand_path(File.join(File.dirname(__FILE__), "helper"))

class USBBetaBriteTest < Test::Unit::TestCase
  def test_write_message
    bb = BetaBrite::USB.new do |sign|
      sign.textfile do
        puts "hello ALIVE!!!"
      end
    end
    assert_equal "hello ALIVE!!!", bb.text_files.first.message
    assert bb.message
    bb.write!
  end

  def test_clear_memory
    BetaBrite::USB.new do |sign|
      sign.clear_memory!
    end
  end
end
