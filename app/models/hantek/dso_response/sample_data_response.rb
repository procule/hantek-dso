module Hantek
  class SampleDataResponse < DSOResponse
    endian    :little
    uint8     :start
    uint16    :len
    uint8     :command
    uint8     :subcommand
    rest      :rest

    attr_reader :sample_len, :data

    def pre_read(io, client)
      read(io)
      s = BinData::IO::Read.new rest
      if subcommand == 0
        @sample_len = BinData::Uint24be.new.read(s.readbytes 3)
        @cs = BinData::Uint8.new.read(s.readbytes 1)
        add_param :sample_len
        add_param :cs

        @c_cs = get_cs [@sample_len]
      elsif subcommand == 1
        @data = BinData::String.new(s.readbytes(s.num_bytes_remaining))

        unless client.nil?
          loop do
            d = client.get_data
            @data = @data.to_s+d
            break if d.length < client.endpoints[:in][:maxsize]
          end
        end
        add_param :data
      end
      add_param :c_cs
      @cs_ok = (@c_cs == hex(@cs))
      add_param :cs_ok
      self
    end

    def inspect (colorize=true)
      hexed = [:start, :command, :subcommand, :len, :cs]
      super colorize, hexed
    end
  end
end

