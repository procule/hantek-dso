class DsoController < ApplicationController
  before_filter :claim_usb
  after_filter  :release_usb

  def echo2
    @packet = PacketFu::EthPacket.new
    @packet.eth_daddr = Mac.first[:address]
    @packet.eth_saddr = PacketFu::Utils.ifconfig('usb0')[:eth_saddr]
    @packet.payload="\x53\x02\x00\x01\x56"
    @packet.to_w('usb0')
  end

  def client
    @vstart = Time.now
    unless params[:clear_queue].nil?
      puts 'packet'
    end
    if params[:read_packet]
      @datastr = @client.get_data
      puts 'GOT DATA'
    end

    if params[:packet_type]
      puts 'WE HAVE PACKET TYPE'
      req = Object.const_get('Hantek::'+params[:packet_type]).new
      req.send(@client)
      @datastr = @client.read_packet(req.buffer_in)
    end
    if @datastr.instance_variable_defined? '@data'
      puts 'WE HAVE @DATA'
      @datastr = @datastr.data
    end
  end



  private
  def claim_usb
    @client=Hantek::Client.new if @client.nil?
  end

  private
  def release_usb
    if @client
      @client.handle.release_interface 0
      @client.handle.close
    end
  end



=begin

  def time
    usb = LIBUSB::Context.new
    @device = usb.devices(:idVendor => 0x049f, :idProduct => 0x505a).first
    @handle = @device.open
    if @handle.kernel_driver_active? 0
      @handle.detach_kernel_driver 0
    end
    @packet = {}
    @packet['out'] = [0x53, 0x02, 0x00, 0x21]
    @packet['out'] << @packet['out'].inject(:+)
    begin
      @handle.claim_interface 0
    rescue LIBUSB::ERROR_BUSY
      @handle.reset_device
      retry
    end

    @packet['out_len'] = @packet['out'].length
    @packet['out_sent'] = @handle.bulk_transfer(:endpoint => 0x2, :dataOut => @packet['out'].pack('c*'))
    if @packet['out_sent'] == @packet['out_len']
      begin
        @packet['in_data'] = @handle.bulk_transfer(:endpoint => 0x81, :dataIn => 512)
      rescue LIBUSB::ERROR_TIMEOUT => e
        @packet['error'] = e
      end

    end
  end

  def sample
    usb = LIBUSB::Context.new
    @device = usb.devices(:idVendor => 0x049f, :idProduct => 0x505a).first
    @handle = @device.open
    if @handle.kernel_driver_active? 0
      @handle.detach_kernel_driver 0
    end

    begin
      @handle.claim_interface 0
    rescue LIBUSB::ERROR_BUSY
      @handle.reset_device
      @handle.detach_kernel_driver 0
      @handle.attach_kernel_driver 0
    end

    @packet = {}
    @packet['out'] = [0x53, 0x04, 0x00, 0x02, 0x01, 0x00]
    @packet['out'] << @packet['out'].inject(:+)

    @packet['out_len'] = @packet['out'].length
    @packet['out_sent'] = @handle.bulk_transfer(:endpoint => 0x2, :dataOut => @packet['out'].pack('c*'))
    if @packet['out_sent'] == @packet['out_len']
      @packet['in_data'] = @handle.bulk_transfer(:endpoint => 0x81, :dataIn => 65536)
    end
  end

  def buzz
    usb = LIBUSB::Context.new
    @device = usb.devices(:idVendor => 0x049f, :idProduct => 0x505a).first
    @handle = @device.open
    if @handle.kernel_driver_active? 0
      @handle.detach_kernel_driver 0
    end

    begin
      @handle.claim_interface 0
    rescue LIBUSB::ERROR_BUSY
      @handle.reset_device
      @handle.detach_kernel_driver 0
      @handle.attach_kernel_driver 0
    end

    @packet = {}
    @packet['out'] = [0x43, 0x02, 0x00, 0x02]
    @packet['out'] << @packet['out'].inject(:+)

    @packet['out_len'] = @packet['out'].length
    @packet['out_sent'] = @handle.bulk_transfer(:endpoint => 0x2, :dataOut => @packet['out'].pack('c*'))
    if @packet['out_sent'] == @packet['out_len']
      @packet['in_data'] = @handle.bulk_transfer(:endpoint => 0x81, :dataIn => 65536)
    end
  end
=end
end



#cmd = [0x43, 0x18, 0x00, 0x11] + map(ord, cmd_str)
#checksum = sum(cmd) & 0xff