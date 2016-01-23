module Hantek
  class DSORequest
    attr_reader :packet, :cs

    def initialize
      @cs = checksum
      @packet << @cs
    end

    def inspect
      {:packet => @packet, :cs => @cs}
    end

    def pack (tstr)
      @packet.pack tstr
    end

    def send (client)
      client.handle.bulk_transfer(:endpoint => client.endpoints[:out][:addr],
                            :dataOut => @packet.pack('c*'))
    end

    def command
      @packet.unpack('H*').first.scan(/../)[3]
    end

    private
    def checksum
      @packet.inject(:+)
    end
  end
end
