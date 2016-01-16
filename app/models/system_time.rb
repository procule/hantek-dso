class SystemTime
  include ActiveModel::Validations

  attr_reader :year, :month, :day, :hour, :minute, :second, :datetime

  validate :check

  def initialize(bytes)
    @bytes = bytes
    if valid?
      bytes_a = @bytes.scan(/../).map.to_a
      @year = (bytes_a[5]+bytes_a[4]).to_i(16)
      @month = bytes_a[6].to_i(16)
      @day = bytes_a[7].to_i(16)
      @hour = bytes_a[8].to_i(16)
      @minute = bytes_a[9].to_i(16)
      @second = bytes_a[10].to_i(16)
      @datetime = DateTime.new(@year,@month,@day,@hour,@minute,@second)
    end
  end

  private
  def check
    if @bytes[0] == 'S'
      @bytes = @bytes.unpack('H*')[0]
    end
    unless @bytes.class == String
      errors.add(:base, 'Argument must be a string')
      return
    end
    unless @bytes.scan(/......(..)/).map.first[0].downcase == 'a1'
      errors.add(:base, 'Not SystemTime command')
      return
    end
    errors.add(:base, 'Bytes string is not recognized (starts with 0x53)') unless @bytes.scan(/../).first == '53'
  end
end
