class Marc4R::MarcStreamReader
  include Enumerable
  def initialize(io, enc=nil)
    @io = io
    @encoding = enc ? Encoding.find(enc) : nil
  end
  def close
    @io.close
  end
  def each
    until @io.eof? do
      leader = @io.read(24)
      record = Marc4R::Record.new(leader)
      record_body = @io.read(record.leader.record_length - 24)
      load_record(record, record_body)
      yield record
    end
  end
  def load_record(record, content)
    leader = record.leader
    dir_length = leader.data_base_address - 25
    raise Marc4R::MarcException.new("invalid directory length #{dir_length}\n#{leader.to_s}\n#{content}") unless (dir_length % 12) == 0
    size = dir_length / 12

    # if MARC 21 then check encoding
    unless @encoding
      if leader.char_coding_scheme.eql? ' '
        @encoding = Encoding.find("ISO-8859-1")
      elsif leader.char_coding_scheme.eql? 'a'
        @encoding = Encoding.find("UTF-8")
      end
    end
    
    tags = []
    lengths = []
    starts = []
    offset = 0
    size.times do
      tags << content.slice(offset,3)
      lengths << content.slice(offset+3,4).to_i
      offset += 12
    end

    unless content[offset] == Marc4R::Terminators::FIELD_TERMINATOR
      raise Marc4R::MarcException.new("expected field terminator at end of directory")
    else
      offset += 1
    end

    (0...size).each do |i|
      field_content = content.slice(offset,lengths[i])
      offset += lengths[i]
      unless field_content[-1] == Marc4R::Terminators::FIELD_TERMINATOR
        raise Marc4R::MarcException.new("expected field terminator at end of field #{field_content}")
      end
      if Marc4R::Fields::ControlField.accepts_tag(tags[i])
        data = field_content[0...-1].force_encoding(@encoding)
        record.control_fields << Marc4R::Fields::ControlField.new(tags[i], data)
      else # read a data field
        record.data_fields << data_field(tags[i],field_content[0...-1])
      end
    end
    unless content[offset] == Marc4R::Terminators::RECORD_TERMINATOR
      raise Marc4R::MarcException.new("expected record terminator")
    end
  end
  def data_field(tag, field_content)
    raise Marc4R::MarcException.new("malformed data data field content") if field_content.size < 2
    ind1 = field_content[0]
    ind2 = field_content[1]

    data_field = Marc4R::Fields::DataField.new(tag, ind1, ind2)
    if field_content[2] == Marc4R::Terminators::SUBFIELD_TERMINATOR
      subfields = field_content[3..-1].split(Marc4R::Terminators::SUBFIELD_TERMINATOR)
      subfields = subfields.collect {|x| [x[0], x.slice(1..-1).force_encoding(@encoding)]}
      subfields.flatten!
    else
      subfields = []
    end
    return Marc4R::Fields::DataField.new(tag, ind1, ind2, *subfields)
  end
end