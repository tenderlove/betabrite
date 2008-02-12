module BetaBrite
  class Memory
    COMMAND_CODE = "E$"
    TEXT         = 'A'
    STRING       = 'B'
    DOTS         = 'D'
    LOCKED       = 'L'
    UNLOCKED     = 'U'
    def self.clear
      BetaBrite::Base::STX << COMMAND_CODE
    end

    attr_accessor :label, :type, :locked, :size, :time
    def initialize(opts = {})
      args = {  :label  => 'A',
                :type   => STRING,
                :locked => LOCKED,
                :size   => sprintf("%04x", 0),
                :time   => '0000'
              }.merge opts
      @label  = args[:label]
      @type   = args[:type]
      @locked = args[:locked]
      @size   = args[:size]
      @time   = args[:time]
      yield self if block_given?
    end

    def format
      "#{@label}#{@type}#{@locked}#{@size.upcase}#{@time}"
    end

    alias :to_s :format

    class Factory
      attr_reader :memory_list
      class << self
        def find(&block)
          @memory_list = []
          block.call(self)
          @memory_list
        end

        def string(label, size)
          @memory_list << String.new(label, size)
        end

        def text(label, size)
          @memory_list << Text.new(label, size)
        end

        def dots(label, rows, columns)
          @memory_list << Dots.new(label, rows, columns)
        end
      end
    end

    class String < Memory
      def initialize(label, size)
        super(  :label  => label,
                :type   => STRING,
                :locked => LOCKED,
                :size   => sprintf("%04x", size),
                :time   => '0000'
             )
      end
    end

    class Text < Memory
      def initialize(label, size)
        super(  :label  => label,
                :type   => TEXT,
                :locked => UNLOCKED,
                :size   => sprintf("%04x", size),
                :time   => 'FF00'
             )
      end
    end

    class Dots < Memory
      def initialize(label, rows, columns)
        size = sprintf("%02x", rows) << sprintf("%02x", columns)
        super(  :label  => label,
                :type   => DOTS,
                :locked => UNLOCKED,
                :size   => size,
                :time   => '4000'
             )
      end
    end

    class Clear < Memory
      def to_s
        "#{BetaBrite::Base::STX}#{COMMAND_CODE}"
      end
    end
  end
end
