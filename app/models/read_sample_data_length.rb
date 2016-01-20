class ReadSampleDataLength < DSOPacket
  endian    :little
  uint8     :start
  uint16    :len
  uint8     :command
  uint8     :subcommand
  uint24    :sample_len
  uint8     :cs

  def read(io={})
    super(io)
    @cs_ok = (get_cs == hex(cs))
    add_param :cs_ok
  end

  def inspect (colorize=true)
    hexed = [:start, :command, :subcommand, :sample_len]
    super colorize, hexed
  end


end