module BetaBrite
  module Files
    class Text
      WRITE   = 0x41.chr
      READ    = 0x42.chr

      class Position
        MIDDLE  = 0x20.chr
        TOP     = 0x22.chr
        BOTTOM  = 0x26.chr
        FILL    = 0x30.chr
        LEFT    = 0x31.chr
        RIGHT   = 0x32.chr
      end

      class Mode
        # Standard Modes
        ROTATE      = 0x61.chr # Message travels right to left
        HOLD        = 0x62.chr # Message remains stationary
        FLASH       = 0x63.chr # Message remains stationary and flashes
        ROLL_UP     = 0x65.chr # Message is pushed up by new message
        ROLL_DOWN   = 0x66.chr # Message is pushed down by new message
        ROLL_LEFT   = 0x67.chr # Message is pushed left by a new message
        ROLL_RIGHT  = 0x68.chr # Message is pushed right by a new message
        WIPE_UP     = 0x69.chr # Message is wiped over bottom to top
        WIPE_DOWN   = 0x6A.chr # Message is wiped over top to bottom
        WIPE_LEFT   = 0x6B.chr # Message is wiped over right to left
        WIPE_RIGHT  = 0x6C.chr # Message is wiped over left to right
        SCROLL      = 0x6D.chr # New message pushes up if 2 line sign
        AUTOMODE    = 0x6F.chr # Various modes are called automatically
        ROLL_IN     = 0x70.chr # Message pushed toward center of display
        ROLL_OUT    = 0x71.chr # Message pushed away from center of display
        WIPE_IN     = 0x72.chr # Message wiped over in inward motion
        WIPE_OUT    = 0x73.chr # Message wiped over in outward motion
        COMPRESSED_ROTATE = 0x74.chr # Left to right, chars half normal width
        EXPLODE     = 0x75.chr # Message flies apart (Alpha 3.0)
        CLOCK       = 0x76.chr # Wipe in clockwise direction (Alpha 3.0)

        # Special Modes
        TWINKLE     = 0x6E.chr << 0x30.chr # Message will twinkle
        SPARKLE     = 0x6E.chr << 0x31.chr # Message will sparkle
        SNOW        = 0x6E.chr << 0x32.chr # Message will snow
        INTERLOCK   = 0x6E.chr << 0x33.chr # Message will interlock
        SWITCH      = 0x6E.chr << 0x34.chr # Message will switch
        SLIDE       = 0x6E.chr << 0x35.chr # Message will slide
        SPRAY       = 0x6E.chr << 0x36.chr # Message will spray across
        STARBURST   = 0x6E.chr << 0x37.chr # Explodes message to screen
        WELCOME     = 0x6E.chr << 0x38.chr # The world "Welcome" is written
        SLOT_MACHINE= 0x6E.chr << 0x39.chr # Slot Machine shows up
        NEWS_FLASH  = 0x6E.chr << 0x3A.chr # News flash animation
        TRUMPET     = 0x6E.chr << 0x3B.chr # Trumpet animation
        CYCLE_COLORS= 0x6E.chr << 0x43.chr # Color changes from one to another

        # Special Graphics
        THANK_YOU   = [0x6E, 0x53].pack('C*') # "Thank You" in script
        FLAG        = [0x6E, 0x54].pack('C*') # American Flag
        NO_SMOKING  = [0x6E, 0x55].pack('C*') # No smoking
        DRINK_DRIVE = [0x6E, 0x56].pack('C*') # Don't drink and drive
        ANIMAL_ANIM = [0x6E, 0x57].pack('C*') # Animal animation
        FIREWORKS   = [0x6E, 0x58].pack('C*') # Fireworks animation
        BALLOONS    = [0x6E, 0x59].pack('C*') # Balloon animation
        CHERRY_BOMB = [0x6E, 0x5A].pack('C*') # A bomb animation or a smile
        SMILE       = [0x6E, 0x5A].pack('C*') # A bomb animation or a smile
      end

      attr_accessor :label, :position, :mode, :message

      include BetaBrite::FileDSL

      def initialize(label = 'A', &block)
        @position = Position::MIDDLE
        @label = label
        @message = nil
        @mode  = Mode::ROTATE
        instance_eval(&block) if block
      end

      def stringfile(label)
      "#{BetaBrite::Base::DLE}#{label}"
      end

      def dotsfile(label)
      "#{BetaBrite::Base::STRING}#{label}"
      end

      def to_s
      "#{combine}#{checksum(combine)}"
      end

      def checksum(string)
        total = 0
        string.unpack('C*').each { |i|
          total += i
        }

        sprintf("%04X", total)
      end

      Mode.constants.each do |constant|
        next unless constant =~ /^[A-Z_]*$/
          define_method(:"#{constant.downcase}") do
            @mode = Mode.const_get(constant)
            self
          end
      end

      Position.constants.each do |constant|
        next unless constant =~ /^[A-Z_]*$/
          define_method(:"#{constant.downcase}") do
            @position = Position.const_get(constant)
            self
          end
      end

      private
      def combine
        "#{BetaBrite::Base::STX}#{WRITE}#{@label}#{BetaBrite::Base::ESC}" +
          "#{@position}#{@mode}#{@message}#{BetaBrite::Base::ETX}"
      end
    end
  end
end
