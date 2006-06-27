$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'betabrite'
require 'serialport'

sp = SerialPort.new(0, 9600, 8, 1, SerialPort::NONE)

sign = BetaBrite.new

string  = BetaBrite::Memory::String.new('0', 32)
dots    = BetaBrite::Memory::Dots.new('1', 7, 7)
text    = BetaBrite::Memory::Text.new('A', 256)

sign.add text
sign.add dots
sign.add string

sign.allocate { |text|
  sp.write text
}

