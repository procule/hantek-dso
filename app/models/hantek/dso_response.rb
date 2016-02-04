module Hantek
  class DSOResponse < BinData::Record
    include ActiveModel::Serialization

    attr_accessor :extra_attr
    attr_reader :data_in, :type

    def self.build(args={})
      data = args[:data]
      client = args[:client]
      if defined?(Pry)
        Pry.config.print = proc { |output, value| output.puts "=> #{value.inspect}" }
      end
      c = ('c_'+data.unpack('H*').first.scan(/../)[3]).to_sym
      puts "COMMAND: #{c}"
      if Hantek::COMMAND[c]
        BinData::Record.instance_eval do
          def pre_read (data, client); end
        end
        if Hantek::HAVE_SUBCMD.include? c
          sc = ('sc_'+data.unpack('H*').first.scan(/../)[3]+'_'+data.unpack('H*').first.scan(/../)[4]).to_sym
          puts "SUBCOMMAND: #{sc}"
          Hantek::SUBCOMMAND[sc].new.pre_read(data, client)
        else
          if Hantek::COMMAND[c].method_defined? :pre_read
            puts 'WE HAVE PRE-READ'
            Hantek::COMMAND[c].new.pre_read(data, client)
          else
            puts 'WE HAVE ONLY READ'
            Hantek::COMMAND[c].read(data, client)
          end
        end
      else
        data
      end
    end

    def result

    end
    def get_command
      @data_in.unpack('H*').first.scan(/../)[3].upcase
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
      f = (get_fields false) - [:rest]
      i = { :type => self.class }
      f.each do |a|
        if a.is_a? Hash
          a[:extra_attr].each do |b|
            i[b] = (b.in?(hexed) ? hex(self.instance_values[b.to_s]) : self.instance_values[b.to_s])
          end
        else
          i[a] = (a.in?(hexed) ? hex(self[a]) : self[a])
        end

      end
      ap i
    end

    def add_param s
      @extra_attr ||= []
      @extra_attr << s
    end

    # @return [Array] Array with all packet fields
    def get_fields(no_extra=true)
      fields = []
      self.instance_values['field_names'].each do |f|
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

    def get_cs(to_add=[])
      sum = 0
      f = get_fields.take get_fields.size-1
      f.each do |n|
        sum = sum + sumit(self[n]) unless self[n].blank?
      end
      to_add.each {|a| sum = sum + sumit(a)}
      hex(((sum)&0xff))
    end

    def le2be(v)

      a = ("%04x" % v.to_i.to_s(2).to_i(2)).scan(/./)
      (a[2]+a[3]+a[0]+a[1]).to_i(16)
    end

    def sumit(v)
      len = v.to_s.length
      len = len+len.modulo(2)

      ("%0#{len}x" % v.to_i).scan(/../).map {|n| n.to_i(16)}.inject(:+)
    end

    def to_hex
      str = ""
      ary = @data_in.unpack('C*')
      ary.each do |n|
        str += (("%02x" % hex(n, false).to_i(16))+' ')
      end
      str
      #("%0#{len}x" % @data_in.to_i).scan(/../)
    end

    private
    def read(io={},client=nil)
      super(io)
      @data_in = io
    end

    def hex(v, string=true)
      unless string
        return v.to_i.to_s(16).upcase
      end
      '0x'+v.to_i.to_s(16).upcase
    end
  end
end
