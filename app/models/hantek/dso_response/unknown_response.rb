module Hantek
  class UnknownResponse < DSOResponse
    endian    :little
    uint8     :start
    uint16    :len
    uint8     :command
    rest      :rest

    def read(io={},client=nil)
      super(io)
    end
  end
end
