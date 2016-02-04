module Hantek
  class SampleDataChannelResponse < DSOResponse
    def pre_read(io={},client=nil)
      read(io)
      self
    end

    def inspect(colorize=true)

    end

    def result

    end
  end
end
