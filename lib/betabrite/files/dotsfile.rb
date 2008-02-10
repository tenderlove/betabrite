module BetaBrite
  module Files
    class Dots
      COMMAND_CODE = 0x49.chr

      attr_accessor :label, :rows, :columns, :picture

      def initialize(label, rows, columns, picture, &block)
        @label    = label
        @rows     = rows
        @columns  = columns
        @picture  = picture
        instance_eval(&block) if block
      end

      def to_s
        string = "#{BetaBrite::Base::STX}#{COMMAND_CODE}#{@label.to_s}" +
        "#{sprintf('%02x', @rows)}#{sprintf('%02x', @columns)}" +
        "#{picture.join(BetaBrite::Base::CR)}#{BetaBrite::Base::CR}"
      end
      alias :to_str :to_s
    end
  end
end
