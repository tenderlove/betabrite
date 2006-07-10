$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

# = Synopsis
# This script shows an example of clearing the memory on the BetaBrite sign.
require 'betabrite'
require 'serialport'

sp = SerialPort.new(0, 9600, 8, 1, SerialPort::NONE)

sign = BetaBrite.new
sign.add BetaBrite::Memory::Clear.new

sign.allocate { |text|
  sp.write text
}

