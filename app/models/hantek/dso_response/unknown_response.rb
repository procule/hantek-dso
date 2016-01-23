module Hantek
  class UnknownResponse < DSOResponse
    def read(io={})
      false
    end
  end
end
