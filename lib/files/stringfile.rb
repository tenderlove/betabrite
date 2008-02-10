class BetaBrite
  class StringFile
    COMMAND_CODE = 'G'

    attr_accessor :label, :message

    def initialize(label = nil, message = nil, &block)
      @label    = label
      @message  = message
      instance_eval(&block)
    end

    def puts(some_string)
      @message = @message ? @message + some_string : some_string
    end

    def string(some_string)
      BetaBrite::String.new(some_string)
    end

    ::BetaBrite::String.constants.each do |constant|
      next unless constant =~ /^[A-Z_]*$/
      define_method(:"#{constant.downcase}") do
        ::BetaBrite::String.const_get(constant)
      end
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
