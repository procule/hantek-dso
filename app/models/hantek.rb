require 'hantek/dso_request/system_time_request'
require 'hantek/dso_request/sample_data_request'
require 'hantek/errors'
require 'hantek/dso_response/unknown_response'
require 'hantek/dso_response/lock_response'
require 'hantek/dso_response/system_time_response'
require 'hantek/dso_response/sample_data_response'
require 'hantek/dso_response/sample_data_channel_response'
require 'hantek/dso_response/sample_data_length_response'
require 'hantek/dso_response/sample_data_packet_response'
require 'hantek/dso_response/sample_data_error_response'


module Hantek
  VERSION = '0.1'

  IDVENDOR = 0x049f
  IDPRODUCT = 0x505a

  HAVE_SUBCMD = [ :c_82 ]

  REQUESTS = [
      SampleDataRequest,
      SystemTimeRequest
  ].inject([]) {|i, a| i.append a.class_name}

  COMMAND = {
      :c_02 => SampleDataRequest,
      :c_21 => SystemTimeRequest,
      :c_82 => SampleDataResponse,
      :c_92 => LockResponse,
      :c_a1 => SystemTimeResponse

  }

  SUBCOMMAND = {
      :sc_82_00 => SampleDataLengthResponse,
      :sc_82_01 => SampleDataPacketResponse,
      :sc_82_02 => SampleDataChannelResponse,
      :sc_82_03 => SampleDataErrorResponse
  }

  def self.testing
    @client=Hantek::Client.new if @client.nil?
    r=Hantek::SampleDataRequest.new
    d=r.send(@client)
    [r,@client,d]
  end
end
