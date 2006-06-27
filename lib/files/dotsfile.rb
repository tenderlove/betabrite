class BetaBrite
  class DotsFile
    COMMAND_CODE = 0x49.chr

    attr_accessor :label, :rows, :columns, :picture

    def initialize(label, rows, columns, picture)
      @label    = label
      @rows     = rows
      @columns  = columns
      @picture  = picture
    end

    def id
      BetaBrite::STRING << @label
    end

    def to_s
      string = "#{BetaBrite::STX}#{COMMAND_CODE}#{@label.to_s}" +
        "#{sprintf('%02x', @rows)}#{sprintf('%02x', @columns)}" +
        "#{picture.join(BetaBrite::CR)}#{BetaBrite::CR}"
    end
  end
end