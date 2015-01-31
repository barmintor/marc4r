class Marc4R::Record

  attr_accessor :leader, :control_fields ,:data_fields

  def initialize(leader = nil)
    self.leader = Leader.new(leader)
    self.control_fields = []
    self.data_fields = []
  end

  def control_number
    control_fields('001').first.data
  end

  def control_number_field
    control_fields('001').first
  end

  def control_fields(*tags)
    tags.empty? ? @control_fields : @control_fields.select {|field| tags.include? field.tag}
  end

  def data_fields(*tags)
    tags.empty? ? @data_fields : @data_fields.select {|field| tags.include? field.tag}
  end

  def find(*args)

    pattern = (args.last.is_a? Regexp) ? args.pop : nil
    fields = (control_fields(*args) + data_fields(*args))
    if pattern
      fields = fields.select {|x| x =~ pattern}
    end
    fields
  end

  class Leader
    attr_accessor :id, :record_length, :record_status, :record_type,
                  :impl_defined1, :char_coding_scheme, :indicator_count,
                  :subfield_code_count, :data_base_address, :impl_defined2, :entry_map

    def initialize(value = nil)
      parse(value) if value
    end
    def eql? x
      (x.is_a? Marc4R::Record::Leader) && self.to_s.eql?(x.to_s)
    end
    private
    def parse(value)
      raise Marc4R::MarcException.new("leader should be 24 characters, was #{value.size}") unless value.size == 24
    # The logical record length (Position 0-4).
      @record_length = value[0..4].to_i
    # The record status (Position 5).
      @record_status = value[5]
    # Type of record (Position 6).
      @record_type = value[6]
    # Implementation defined (Position 7-8).
      @impl_defined1 = [value[7],value[8]]
    # Character coding scheme (Position 9).
      @char_coding_scheme = value[9]
    # The indicator count (Position 10).
      @indicator_count = value[10].to_i
    # The subfield code length (Position 11).
      @subfield_code_count = value[11].to_i
    # The base address of data (Position 12-16).
      @data_base_address = value[12..16].to_i
    # Implementation defined (Position 17-18).
      @impl_defined2 = [value[17],value[18]]
    # Entry map (Position 19-23).
      @entry_map = (19..23).collect {|x| value[x]}
    end
    def zero_pad(int, min_length)
      log = (int > 0) ? Math.log10(int).ceil : 1
      (log < min_length) ? (0...min_length-log).inject(int.to_s) {|m,v| m.prepend '0'}
                         : int.to_s
    end
    public
    def to_s
      strings = @record_length ? [zero_pad(@record_length,5)] : []
      strings << @record_status if @record_status
      strings << @record_type if @record_type
      strings += @impl_defined1 if @impl_defined1
      strings << @char_coding_scheme if @char_coding_scheme
      strings << @indicator_count.to_s if @indicator_count
      strings << @subfield_code_count.to_s if @subfield_code_count
      strings << zero_pad(@data_base_address,5) if @data_base_address
      strings += @impl_defined2 if @impl_defined2
      strings += @entry_map if @entry_map
      strings.join('')
    end
  end
end