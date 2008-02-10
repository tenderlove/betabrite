module BetaBrite
  module FileDSL
      def print(some_string)
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
  end
end
