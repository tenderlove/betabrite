require 'files/textfile'
require 'files/stringfile'
require 'files/dotsfile'
require 'memory/memory'
require 'string'
require 'bb_version'

# = Synopsis
# This class assembles all packets (different files) and yields the data
# that needs to be written back to the caller of the BetaBrite#write method.
class BetaBrite
  HEADER    = [ 0x00, 0x00, 0x00, 0x00, 0x00, 0x01 ]
  STX       = 0x02.chr
  ETX       = 0x03.chr
  EOT       = 0x04.chr
  ESC       = 0x1b.chr
  DLE       = 0x10.chr
  STRING    = 0x14.chr
  CR        = 0x0d.chr
  MEMORY_CODE = "E$"

  # Beta Brite sign
  SIGN_TYPE = 0x5a.chr

  attr_reader :sleep_time
  attr_reader :string_files, :text_files, :dots_files

  def initialize
    # Default address is "00" which means broadcast to all signs
    @sign_address = [ 0x30, 0x30 ]
    @string_files = []
    @text_files   = []
    @dots_files   = []
    @memory       = []

    # This shouldn't change except for unit testing
    @sleep_time = 1
    yield self if block_given?
  end

  def header
    header_str = HEADER.collect { |a| a.chr }.join
    header_str << SIGN_TYPE << @sign_address.collect { |a| a.chr }.join
  end

  def inspect
    header
  end

  def add(packet)
    if packet.is_a? BetaBrite::Memory
      add_memory packet
    elsif packet.is_a? BetaBrite::StringFile
      add_stringfile packet
    elsif packet.is_a? BetaBrite::TextFile
      add_textfile packet
    elsif packet.is_a? BetaBrite::DotsFile
      add_dotsfile packet
    end
  end

  def add_stringfile(packet)
    @string_files << packet
  end

  def add_textfile(packet)
    @text_files << packet
  end

  def add_dotsfile(packet)
    @dots_files << packet
  end

  def add_memory(packet)
    @memory << packet
  end

  # This method is used to write on the sign
  def write(&block)
    if @text_files.length > 0 || @string_files.length > 0
      write_header &block
      @text_files.each { |packet| yield packet.to_s }
      @string_files.each { |packet| block.call(packet.to_s) }
      write_end &block
    end
  end

  def write_dots(&block)
    if @dots_files.length > 0
      write_header &block
      @dots_files.each { |packet|
        yield packet.to_s
        sleep sleep_time
      }
      write_end &block
    end
  end

  # This method is used to allocate memory on the sign
  def allocate(&block)
    if @memory.length > 0
      write_header &block
      yield STX
      yield MEMORY_CODE
      @memory.each { |packet| yield packet.to_s }
      write_end &block
    end
  end

  private

  def write_header(&block)
    header.split(//).each { |c|
      yield c
      sleep sleep_time
    }
  end

  def write_end(&block)
    yield EOT
  end
end
