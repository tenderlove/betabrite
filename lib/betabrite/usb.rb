module BetaBrite
  class USB < Base
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

    def reset!
      write_memory!
    end

    def write_memory!
      device = usb_device()
      handle = usb_interface(device)
      handle.usb_bulk_write(WRITE_ENDPOINT, memory_message, WRITE_TIMEOUT)
      handle.usb_bulk_write(WRITE_ENDPOINT, memory_message, WRITE_TIMEOUT)
      handle.usb_close
    end

    def write!
      device = usb_device()
      handle = usb_interface(device)
      handle.usb_bulk_write(WRITE_ENDPOINT, message, WRITE_TIMEOUT)
      handle.usb_bulk_write(WRITE_ENDPOINT, message, WRITE_TIMEOUT)
      handle.usb_close
    end

    private
    def usb_device
      ::USB.devices.find { |d|
        d.idProduct == PRODUCT_ID && d.idVendor == VENDOR_ID
      } || raise("Unable to locate the BETABrite.")
    end

    def usb_interface(device)
      handle = device.usb_open
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
end
