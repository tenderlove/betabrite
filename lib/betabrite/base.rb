module BetaBrite
  VERSION   = '1.0.1'

  class Base
    include BetaBrite::Files

    # = Synopsis
    # This class assembles all packets (different files) and yields the data
    # that needs to be written back to the caller of the BetaBrite#write method.
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

    attr_accessor :sleep_time
    attr_reader :string_files, :text_files, :dots_files, :memory

    def initialize
      # Default address is "00" which means broadcast to all signs
      @sign_address = [ 0x30, 0x30 ]
      @string_files = []
      @text_files   = []
      @dots_files   = []
      @memory       = []

      # This shouldn't change except for unit testing
      @sleep_time = 0
      yield self if block_given?
    end

    def textfile(label = 'A', &block)
      @text_files << Text.new(label, &block)
    end

    def stringfile(label, message = nil, &block)
      @string_files << Files::String.new(label, message, &block)
    end

    def dotsfile(label, rows = nil, columns = nil, picture = nil, &block)
      @dots_files << Dots.new(label, rows, columns, picture,&block)
    end

    def allocate(&block)
      @memory.push(*(BetaBrite::Memory::Factory.find(&block)))
    end

    def clear_memory!
      @memory = []
      self.write_memory!
    end

    # Get the message to be sent to the sign
    def message
      header +
        @text_files.each { |tf| tf.to_s }.join('') +
        @string_files.each { |tf| tf.to_s }.join('') +
        @dots_files.each { |tf| tf.to_s }.join('') +
        tail
    end

    def memory_message
    "#{header}#{STX}#{MEMORY_CODE}#{@memory.map { |packet| packet.to_s }.join('')}#{tail}"
    end

    private

    def header
      header_str = HEADER.collect { |a| a.chr }.join
      "#{header_str}#{SIGN_TYPE}#{@sign_address.collect { |a| a.chr }.join}"
    end
    alias :inspect :header
    public :inspect

    def tail
      EOT
    end
  end
end
