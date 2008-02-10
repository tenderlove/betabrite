$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'betabrite'
require 'usb'

class UsbBetabrite
  # USB Device Codes
  PRODUCT_ID     = 0x1234
  VENDOR_ID      = 0x8765
  INTERFACE      = 0x00
  RECV_LENGTH    = 0x40 # Max Packet Size of 64
  SEND_LENGTH    = 0x40 # Max Packet Size of 64
  WRITE_ENDPOINT = 0x02 
  READ_ENDPOINT  = 0x82
  WRITE_TIMEOUT  = 5000
  READ_TIMEOUT   = 5000

  # Creates a new interface between ruby and the Betabrite
  def initialize
    @device = get_usb_device()
    @handle = get_usb_interface(@device)
  end

  def write(bytes)
    # write twice to force past the 'data toggle bit' check
    #@handle.usb_bulk_write(WRITE_ENDPOINT, bytes.pack('C*'), WRITE_TIMEOUT)
    @handle.usb_bulk_write(WRITE_ENDPOINT, bytes, WRITE_TIMEOUT)
  end
  
  private
  
  def get_usb_device
    device = USB.devices.find {|d| d.idProduct == PRODUCT_ID and d.idVendor == VENDOR_ID }
    raise "Unable to locate the BETABrite." if device.nil?
    return device
  end
  
  def get_usb_interface(device)
    handle = device.open
    raise "Unable to obtain a handle to the device." if handle.nil?

    retries = 0
    begin
      error_code = handle.usb_claim_interface(INTERFACE)
      raise unless error_code.nil?
    rescue
      handle.usb_detach_kernel_driver_np(INTERFACE);
      if retries.zero? 
        retries += 1
        retry
      else
        raise "Unable to claim the device interface."
      end
    end
    
    raise "Unable to set alternative interface." unless handle.set_altinterface(0).nil?

    handle
  end
end

betabrite = UsbBetabrite.new

sign = BetaBrite.new
sign.sleep_time = 0

0.upto(9) { |i| 
  string  = BetaBrite::Memory::String.new(i.to_s, 64)
  sign.add string
}

text    = BetaBrite::Memory::Text.new('A', 4096)

sign.add text

write_text = ''
sign.allocate { |text|
  write_text << text
}
betabrite.write write_text

