$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'betabrite'
require 'serialport'

sp = SerialPort.new(0, 9600, 8, 1, SerialPort::NONE)

sign = BetaBrite.new

0.upto(9) { |i| 
  string  = BetaBrite::Memory::String.new(i.to_s, 64)
  sign.add string
}

text    = BetaBrite::Memory::Text.new('A', 4096)

sign.add text

sign.allocate { |text|
  sp.write text
}

