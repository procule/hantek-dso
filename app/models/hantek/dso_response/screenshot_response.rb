module Hantek
  class ScreenshotResponse < DSOResponse
    endian    :little
    uint8     :start
    uint16    :len
    uint8     :command
    uint8     :subcommand
    rest      :rest

    def pre_read(io={},client=nil)
      read(io)
      ref = rest[0..rest.size-2] #.unpack('H*')[0].scan(/../).map {|h| (h.to_i(16)&0x80)}.join
      @data_in = ref

      @cs = rest[-1].unpack('H*')[0].to_i(16)
      a = rest[-1].unpack('H*')[0].scan(/../).map {|b| b.hex}
      c_cs = (a.inject(0x0) {|sum, v| sum+v.to_s(16).to_i(16)}&0xff).to_s(16).to_i(16)


      @length = a.size-1
      add_param :length
      add_param :cs
      @cs_ok = (c_cs == @cs)
      add_param :cs_ok
      self
    end

    def inspect(colorize=true)
      hexed = [:cs, :command, :subcommand]
      super colorize, hexed
    end
  end
end

