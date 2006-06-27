class BetaBrite
  class StringFile
    COMMAND_CODE = 'G'

    attr_accessor :label, :message

    def initialize(label = nil, message = nil)
      @label    = label
      @message  = message
      yield self if block_given?
    end

    def id
      "#{BetaBrite::DLE}#{@label}"
    end

    def to_s
      "#{BetaBrite::STX}#{COMMAND_CODE}#{@label.to_s}" +
      "#{@message.to_s}#{BetaBrite::ETX}"
    end
  end
end
