module Hantek
  class SystemTimeRequest < DSORequest
    def initialize
      @packet = [0x53, 0x02, 0x00, 0x21]
      super
    end
  end
end
