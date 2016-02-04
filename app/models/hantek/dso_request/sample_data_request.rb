module Hantek
  class SampleDataRequest < DSORequest
    attr_reader :command, :subcommand, :channel

    def initialize
      @command = 0x02
      @subcommand = 0x01
      @channel = 0x00
      @packet = [0x53, 0x04, 0x00, @command, @subcommand, @channel]
      super
    end
  end
end
