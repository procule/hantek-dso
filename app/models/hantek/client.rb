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

      @handle.claim_interface 0
      @timeout = timeout
      @endpoints = Hash.new
      device.endpoints.each do |e|
        @endpoints[e.direction] = { :addr => e.bEndpointAddress }
        @endpoints[e.direction][:maxsize] = device.max_packet_size e
      end
    end

    def read_packet
      begin
        p = @handle.bulk_transfer :endpoint => @endpoints[:in][:addr], :dataIn => @endpoints[:in][:maxsize],
                              :timeout => @timeout
        DSOResponse.build p

      rescue LIBUSB::ERROR_TIMEOUT
        return false
      end
    end

    def get_data
      begin
        @handle.bulk_transfer :endpoint => @endpoints[:in][:addr], :dataIn => @endpoints[:in][:maxsize],
                                  :timeout => @timeout
      rescue LIBUSB::ERROR_TIMEOUT
        return false
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

    def close
      @handle.release_interface 0
    end
  end
end
