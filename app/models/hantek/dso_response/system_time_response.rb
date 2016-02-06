module Hantek
  class SystemTimeResponse < DSOResponse
    endian    :little
    uint8     :start
    uint16    :len
    uint8     :command
    uint16    :year
    uint8     :month
    uint8     :day
    uint8     :hour
    uint8     :minute
    uint8     :second
    uint8     :cs

    attr_reader :datetime

    def read(io={},client=nil)
      super(io)
      @datetime = DateTime.new(year,month,day,hour,minute,second)
      add_param :datetime
      @cs_ok = (get_cs == hex(cs))
      add_param :cs_ok
      self
    end

    def inspect (colorize=true)
      hexed = [:start, :command]
      super colorize, hexed
    end

    def result
      @datetime
    end
  end
end
