$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'serialport'
require 'betabrite'

sp = SerialPort.new(0, 9600, 8, 1, SerialPort::NONE)

sign = BetaBrite.new
tf = BetaBrite::TextFile.new
tf.message = ARGV[0]

sign.add tf

sign.write { |text|
  sp.write text
}

