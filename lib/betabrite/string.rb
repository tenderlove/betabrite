module BetaBrite
  # This class encapsulates a string and attributes about the string such as
  # color, character set, and also contains special characters.
  class String
    LEFT_ARROW      = 0xc6.chr
    RIGHT_ARROW     = 0xc6.chr
    PACKMAN         = 0xc8.chr
    SAIL_BOAT       = 0xc9.chr
    BALL            = 0xca.chr
    TELEPHONE       = 0xcb.chr
    HEART           = 0xcc.chr
    CAR             = 0xcd.chr
    HANDICAP        = 0xce.chr
    RHINO           = 0xcf.chr
    MUG             = 0xd0.chr
    SATELLITE_DISH  = 0xd1.chr
    COPYRIGHT       = 0xd2.chr
    MALE_SYM        = 0xd3.chr
    FEMALE_SYM      = 0xd4.chr
    BOTTLE          = 0xd5.chr
    DISKETTE        = 0xd6.chr
    PRINTER         = 0xd7.chr
    NOTE            = 0xd8.chr
    INFINITY        = 0xd9.chr
    class Color
      RED       = '1'
      GREEN     = '2'
      AMBER     = '3'
      DIM_RED   = '4'
      DIM_GREEN = '5'
      BROWN     = '6'
      ORANGE    = '7'
      YELLOW    = '8'
      RAINBOW_1 = '9'
      RAINBOW_2 = 'A'
      COLOR_MIX = 'B'
      AUTOCOLOR = 'C'
    end
    class CharSet
      FIVE_HIGH     = '1'
      FIVE_STROKE   = '2'
      SEVEN_HIGH    = '3'
      SEVEN_STROKE  = '4'
      SEVEN_FANCY   = '5'
      TEN_HIGH      = '6'
      SEVEN_SHADOW  = '7'
      FULL_FANCY    = '8'
      FULL_HEIGHT   = '9'
      SEVEN_SHDW_F  = ':'
      FIVE_WIDE     = ';'
      SEVEN_WIDE    = '<'
      SEVEN_WIDE_F  = '='
      WIDE_SRK_FIVE = '>'
    end
    attr_accessor :color, :charset, :string

    class << self
      # Break up a string into betabrite strings
      def parse(string)
        string.split(/#{0x1a.chr}/).select { |s|
          s.length > 0
        }.map { |s|
          data = /(.)#{0x1c.chr}Z?([^Z]{6}|[^Z])(.*)$/.match(s)
          new(data[3], :color => data[2], :charset => data[1])
        }
      end
    end

    def initialize(string, opts = {})
      args = {  :color    => Color::GREEN,
                :charset  => CharSet::SEVEN_HIGH
             }.merge opts
      @string   = string
      @color    = args[:color]
      @charset  = args[:charset]
      yield self if block_given?
    end

    def +(other)
      self.to_s + other.to_s
    end

    def rgb(rgb_color)
      self.color = "#{rgb_color}"
      self
    end

    def to_s
      "#{0x1a.chr}#{@charset}#{0x1c.chr}" +
        (@color.length > 1 ? "Z#{@color}" : "#{@color}") +
        "#{@string}"
    end
    alias :to_str :to_s

    Color.constants.each do |constant|
      next unless constant =~ /^[A-Z_]*$/
      define_method(:"#{constant.downcase}") do
        @color = Color.const_get(constant)
        self
      end
      define_method(:"#{constant.downcase}?") do
        @color == Color.const_get(constant)
      end
    end

    CharSet.constants.each do |constant|
      next unless constant =~ /^[A-Z_]*$/
      define_method(:"#{constant.downcase}") do
        @charset = CharSet.const_get(constant)
        self
      end
    end
  end
end
