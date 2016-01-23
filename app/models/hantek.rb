require 'hantek/dso_response'
require 'hantek/dso_request/system_time_request'
require 'hantek/client'
require 'hantek/errors'
require 'hantek/dso_response/unknown_response'
require 'hantek/dso_response/lock_response'
require 'hantek/dso_response/system_time_response'
require 'hantek/dso_response/read_sample_data_length_response'

module Hantek
  VERSION = '0.1'

  IDVENDOR = 0x049f
  IDPRODUCT = 0x505a

  COMMAND = {
      :c_a1 => SystemTimeResponse,
      :c_92 => LockResponse
  }
end
