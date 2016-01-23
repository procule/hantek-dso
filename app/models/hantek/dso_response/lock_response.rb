module Hantek
  class LockResponse < DSOResponse
    endian    :little
    uint8     :start
    uint16    :len
    uint8     :command
    uint8     :subcommand
    uint8     :lock

    def read(io={})
      super(io)
    end

  end
end
