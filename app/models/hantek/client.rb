module Hantek
  class Client
    attr_reader :handle, :endpoints
    def initialize(timeout=1000)
      usb = LIBUSB::Context.new
      device = usb.devices(:idVendor => Hantek::IDVENDOR, :idProduct => Hantek::IDPRODUCT).first
      raise Hantek::DeviceNotFound, 'No Hantek device found' if device.nil?
      @handle = device.open

      if LIBUSB.has_capability? :CAP_SUPPORTS_DETACH_KERNEL_DRIVER
        @handle.auto_detach_kernel_driver = true
      else
        @handle.detach_kernel_driver 0
      end
      begin
        @handle.claim_interface 0
      rescue LIBUSB::ERROR_BUSY
        self.reset
        retry
      end

      @timeout = timeout
      @endpoints = Hash.new
      device.endpoints.each do |e|
        @endpoints[e.direction] = { :addr => e.bEndpointAddress }
        @endpoints[e.direction][:maxsize] = e.wMaxPacketSize
      end
    end

    def read_packet
      begin
        p = @handle.bulk_transfer :endpoint => @endpoints[:in][:addr], :dataIn => @endpoints[:in][:maxsize],
                              :timeout => @timeout

        DSOResponse.build({:data => p, :client => self})

      rescue LIBUSB::ERROR_TIMEOUT
        return false
      end
    end

    def get_data
      begin
        @handle.bulk_transfer :endpoint => @endpoints[:in][:addr], :dataIn => @endpoints[:in][:maxsize],
                                  :timeout => @timeout
      rescue LIBUSB::ERROR_TIMEOUT
        return 'ERROR TIMEOUT'
      end
    end

    def get_time
      r = SystemTimeRequest.new
      len = r.send(self)
      if len == r.packet.length
        begin
          p = read_packet
          raise Hantek::IOError if p.nil?
          raise Hantek::LockError if p.class == Hantek::LockResponse
        rescue Hantek::IOError, Hantek::LockError
          retry
        end
        p
      else
        false
      end
    end

    def each_pair
      {:client => self}
    end

    def reset
      @handle.reset_device
      @handle.detach_kernel_driver 0
    end
  end
end
