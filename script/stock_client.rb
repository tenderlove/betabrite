$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'betabrite'
require 'stockdata'
require 'serialport'

sp = SerialPort.new(0, 9600, 8, 1, SerialPort::NONE)

sd = StockData.new(%w{ ^DJI CSCO DIS GM GPS LU MAT PER PFE UNTD })

sign = BetaBrite.new
tf = BetaBrite::TextFile.new { |a|
  a.mode = BetaBrite::TextFile::Mode::COMPRESSED_ROTATE
}

string = ''
sd.each_with_index do |stock, i|
  color = BetaBrite::String::Color::AMBER
  if stock.change =~ /^[+]/
    color = BetaBrite::String::Color::GREEN
  elsif stock.change =~ /^[-]/
    color = BetaBrite::String::Color::RED
  end
  s = BetaBrite::String.new(
    "#{stock.symbol} #{stock.last_trade} #{stock.change}",
    :color => color
  )
  t = BetaBrite::StringFile.new(i.to_s, s)
  sign.add t
  string << "#{t.id} "
end

tf.message = BetaBrite::String.new(string.strip)

#sign.add tf

sign.write { |text|
  sp.write text
}

