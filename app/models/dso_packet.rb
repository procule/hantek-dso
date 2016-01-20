class DSOPacket < BinData::Record
  include ActiveModel::Serialization

  attr_accessor :extra_attr
  attr_reader :data_in

  def get_command
    @data_in.unpack('H*').first.scan(/../)[3].upcase
  end

  def read(io={})
    super(io)
    @data_in = io
  end

  def attributes
    a = {}
    get_fields('true').each do |f|
      a[f] = nil
    end
    a
  end

  # @param [Object] color
  def inspect(colorize=true, hexed=[])
    f = get_fields false
    i = {}
    f.each do |a|
      if a.is_a? Hash
        a[:extra_attr].each do |b|
          i[b] = (b.in?(hexed) ? hex(self.instance_values[b.to_s]) : self.instance_values[b.to_s])
        end
      else
        i[a] = (a.in?(hexed) ? hex(self[a]) : self[a])
      end

    end
    i
  end

  def add_param s
    @extra_attr ||= []
    @extra_attr << s
  end

  # @return [Array] Array with all packet fields
  def get_fields(no_extra=true)
    fields = []
    instance_values['field_names'].each do |f|
      fields << f
    end

    unless no_extra
      fields << {:extra_attr => []}
      if @extra_attr
        @extra_attr.each do |f|
          fields.last[:extra_attr] << f
        end
      end
    end
    fields
  end

  def get_cs
    sum = 0
    get_fields.each do |n|
      sum = sum + sumit(self[n])
    end
    hex(((sum)&0xff))
  end

  def le2be(v)
    a = ("%04x" % v.to_i.to_s(2).to_i(2)).scan(/./)
    (a[2]+a[3]+a[0]+a[1]).to_i(16)
  end

  def sumit(v)
    v.to_hex.scan(/../).map {|n| n.to_i(16)}.inject(:+)
  end

  def hex(v, string=true)
    unless string
      return v.to_i.to_s(16).upcase
    end
    '0x'+v.to_i.to_s(16).upcase
  end
end