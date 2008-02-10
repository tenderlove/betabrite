module BetaBrite
  module Files
    class String
      COMMAND_CODE = 'G'

      attr_accessor :label, :message
      include BetaBrite::FileDSL

      def initialize(label = nil, message = nil, &block)
        @label    = label
        @message  = message
        instance_eval(&block) if block
      end

      def to_s
        "#{BetaBrite::Base::STX}#{COMMAND_CODE}#{@label.to_s}" +
          "#{@message.to_s}#{BetaBrite::Base::ETX}"
      end
      alias :to_str :to_s
    end
  end
end
