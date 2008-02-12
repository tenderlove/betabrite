module BetaBrite
  class Serial < Base
    def initialize(serialport)
      @serialport = serialport
      super()
    end

    def write_memory!
      sp = SerialPort.new(@serialport, 9600, 8, 1, SerialPort::NONE)
      characters = 0
      memory_message.split(//).each do |chr|
        sleep 1 if characters < 6
        sp.write chr
        characters += 1
      end
    end

    def write!
      sp = SerialPort.new(@serialport, 9600, 8, 1, SerialPort::NONE)
      characters = 0
      message.split(//).each do |chr|
        sleep 1 if characters < 6
        sp.write chr
        characters += 1
      end
    end
  end
end
