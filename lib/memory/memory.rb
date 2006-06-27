class BetaBrite
  class Memory
    COMMAND_CODE = "E$"
    TEXT         = 'A'
    STRING       = 'B'
    DOTS         = 'D'
    LOCKED       = 'L'
    UNLOCKED     = 'U'
    def self.clear
      BetaBrite::STX << COMMAND_CODE
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
      #BetaBrite::STX << COMMAND_CODE << @label << @type << @locked <<
      @label << @type << @locked << @size.upcase << @time
    end

    alias :to_s :format

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
        "#{BetaBrite::STX}#{COMMAND_CODE}"
      end
    end
  end
end
