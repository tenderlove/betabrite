$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

# = Synopsis
# This script shows an example of setting a volitile StringFile, and
# referencing the StringFile from the TextFile.

require 'betabrite'
require 'serialport'

sp = SerialPort.new(0, 9600, 8, 1, SerialPort::NONE)

sign = BetaBrite.new

# Create a new TextFile with the COMPRESSED_ROTATE mode.
tf = BetaBrite::TextFile.new { |a|
  a.mode = BetaBrite::TextFile::Mode::COMPRESSED_ROTATE
}

# Set up a BetaBrite::String
hello_string = BetaBrite::String.new('James',
                                  :color => BetaBrite::String::Color::AMBER
                                )
# Create a StringFile which can be modified without making the sign blink.
sf = BetaBrite::StringFile.new('0', hello_string)

# Create a dots file
dots = BetaBrite::DotsFile.new('1', 7, 7, [])

# Set the TextFile message and reference the StringFile and DotsFile
tf.message = BetaBrite::String.new("#{dots.id} Aaron #{sf.id} Patterson")


sign.add tf
sign.add sf 

sign.write { |text|
  sp.write text
}

