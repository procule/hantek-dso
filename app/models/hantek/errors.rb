module Hantek
  class DeviceNotFound < StandardError; end
  class IOError < StandardError; end
  class LockError < StandardError; end
end