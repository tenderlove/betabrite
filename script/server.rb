require 'drb'
require 'serialport'

class TestServer
  def tty
    sp = SerialPort.new(0, 9600, 8, 1, SerialPort::NONE)
  end
end

server = TestServer.new
DRb.start_service('druby://localhost.org:9000', server)
DRb.thread.join
