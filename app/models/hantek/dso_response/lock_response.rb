module Hantek
  class LockResponse < DSOResponse
    endian    :little
    uint8     :start
    uint16    :len
    uint8     :command
    uint8     :subcommand
    uint8     :lock
    uint8     :cs

    def read(io={},client=nil)
      super(io)
      @cs_ok = (get_cs == hex(cs))
      add_param :cs_ok
      self
    end

  end
end
