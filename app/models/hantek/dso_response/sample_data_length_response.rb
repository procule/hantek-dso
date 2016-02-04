module Hantek
  class SampleDataLengthResponse < DSOResponse
    endian    :little
    uint8     :start
    uint16    :len
    uint8     :command
    uint8     :subcommand
    uint24    :len_cmd
    uint8     :cs

    def pre_read(io={},client=nil)
      read(io)
      self
    end

    def inspect(colorize=true)

    end

    def result
      len_cmd.to_i
    end

  end
end