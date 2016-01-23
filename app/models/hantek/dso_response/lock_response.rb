module Hantek
  class LockResponse < DSOResponse
    endian    :little
    uint8     :start
    uint16    :len
    uint8     :command
    uint8     :subcommand
    uint8     :lock
    uint8     :cs

    def read(io={})
      super(io)
    end

  end
end
