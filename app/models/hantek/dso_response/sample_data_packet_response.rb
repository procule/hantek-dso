module Hantek
  class SampleDataPacketResponse < DSOResponse
    endian    :little
    rest      :rest

    def pre_read(io={},client=nil)
      read(io)

      @cs = @data_in[-1].unpack('H*')[0].to_i(16)
      a = @data_in.unpack('H*')[0].scan(/../).map {|b| b.hex}
      c_cs = (a[0..a.size-2].inject(0x0) {|sum, v| sum+v.to_s(16).to_i(16)}&0xff).to_s(16).to_i(16)


      @length = a.size-2
      add_param :length
      add_param :cs
      @cs_ok = (c_cs == @cs)
      add_param :cs_ok
      self
    end

    def inspect(colorize=true)
      hexed = [:cs]
      super colorize, hexed
    end

    def result
      super
      @data_in[6..@data_in.size-2].unpack('H*')[0].scan(/../).map {|b| signed(b.hex)}
    end

    def chart_data

    end

    private
    def signed b
      (b&0x80).zero? ? b : b-0xff
    end

  end
end
