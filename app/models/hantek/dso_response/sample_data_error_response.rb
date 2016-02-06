class SampleDataErrorResponse < Hantek::DSOResponse
  endian    :little
  uint8     :start
  uint16    :len
  uint8     :command
  uint8     :subcommand
  uint8     :channel
  uint8     :cs

  def pre_read(io={},client=nil)
    read(io)
    @cs_ok = (get_cs == hex(cs))
    add_param :cs_ok
    self
  end

  def inspect(colorize=true)

  end

  def result
    'Error response'
  end

end