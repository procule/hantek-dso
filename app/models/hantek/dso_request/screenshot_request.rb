module Hantek
  class ScreenshotRequest < DSORequest
    def initialize
      @packet = [0x53, 0x02, 0x00, 0x20]
      super
    end

    def buffer_in
      10214
    end
  end
end
