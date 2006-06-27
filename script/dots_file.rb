$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'betabrite'
require 'serialport'

def rand_string(len = 7)
  chars = ("1".."3").to_a
  3.times { chars << "0" }
  string = ""
  1.upto(len) { |i| string << chars[rand(chars.size)] }
  string
end

sp = SerialPort.new(0, 9600, 8, 1, SerialPort::NONE)

sign = BetaBrite.new

pic = [
        rand_string,
        rand_string,
        rand_string,
        rand_string,
        rand_string,
        rand_string,
        rand_string,
      ]

dots = BetaBrite::DotsFile.new('1', 7, 7, pic)

sign.add dots 

sign.write_dots { |text|
  sp.write text
}

