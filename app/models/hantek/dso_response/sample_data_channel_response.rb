module Hantek
  class SampleDataChannelResponse < DSOResponse
    def pre_read(io={},client=nil)
      read(io)
      @cs_ok = (get_cs == hex(cs))
      add_param :cs_ok
      self
    end

    def inspect(colorize=true)

    end

    def result

    end
  end
end
