= BetaBrite Library

* http://rubyforge.org/projects/betabrite/
* http://betabrite.rubyforge.org/
* mailto:aaron@tenderlovemaking.com

== DESCRIPTION

Provides a Ruby interface to BetaBrite LED signs.

== DEPENDENCIES

  * ruby-usb[http://raa.ruby-lang.org/project/ruby-usb/]
  * ruby-serialport[http://rubyforge.org/projects/ruby-serialport/]

PLEASE NOTE!!!!  You must require 'usb' or 'serialport' depending on which
sign you are using!!!!

== More Information

The BetaBrite sign has memory that can be configured before any messages are
displayed.  There are different types of "Files" that can be allocated.
"Text Files" are files that are displayed on the sign.  To display any other
type of file on the sign, that file must be referenced from a Text File.  Files
must be labeled, and are given a single character file name.  The default text
file displayed on the sign is labeled 'A'.

Here is an example of modifying the default sign text:

  bb = BetaBrite::Serial.new('/dev/ttyUSB0') do |sign|
    sign.textfile do
      print ARGV[0]
    end
  end
  bb.write!

== Autotest Support
Here is an example of a .autotest file using the BetaBrite module:

  require 'betabrite/autotest'
  require 'usb'
  
  Autotest::BetaBrite.hook(BetaBrite::USB) do |failures, erorrs|
    failures.rgb('0000FF') if failures.green?
  end

You don't need to give the hook method a block, but you can if you'd like to
customize your messages.

== Allocating Memory
The memory in the BetaBrite sign should be configured before anything is
written to it.  You only have to configure the memory once before writing to
it.  So subsequent executions of your script do not require allocating memory.

Here is an example of allocating memory on the sign:

  bb = BetaBrite::Serial.new('/dev/ttyUSB0') do |sign|
    sign.allocate do |memory|
      memory.text('A', 4096)
      memory.string('0', 64)
    end
  end
  bb.write_memory!

For more examples, see the EXAMPLES file.

== Different File Types
=== Text Files
The data stored in a text file is not supposed to change frequently.  If the
data in a text file is changed, the sign will go blank before anything is
displayed.  This is not good for applications like a stock ticker which
update data quite frequently.  This problem can be avoided by having the
text file reference more volitile files like String Files.

=== String Files
String files contain more volitile memory.  The contents of a String File
can be changed without the screen going blank.  String Files, however, cannot
be displayed unless referenced from a Text File.

Here is an example of referencing a String File from a Text File:

  bb = BetaBrite::Serial.new('/dev/ttyUSB0') do |sign|
    sign.stringfile('0') do
      print string("cruel").red
    end

    sign.textfile do
      print string("Goodbye ").green
      print stringfile("0")
      print string(" world.").green + sail_boat
    end
  end
  bb.write!

Once the String file is allocated and displayed, it can be changed at any
time and the string will be updated without the screen going blank.

=== Dots Files
Dots files can contain pictures.  Each pixel is set in an array of strings.
See dots_file.rb under the script directory for an example.  Or see the
EXAMPLES file.

== Author

* {Aaron Patterson}[http://tenderlovemaking.com] <aaronp@rubyforge.org>

