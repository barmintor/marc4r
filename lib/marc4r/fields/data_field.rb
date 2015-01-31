class Marc4R::Fields::DataField
  include Marc4R::Fields::Idable
  include Marc4R::Fields::Taggable
  attr_accessor :indicator1, :indicator2
  def initialize(tag=nil, ind1=nil, ind2=nil, *args)
    self.tag= tag if tag
    self.indicator1 = ind1 if ind1
    self.indicator2 = ind2 if ind2
    @subfields = []
    args.each_slice(2) do |slice|
      if (slice[0].size != 1)
        raise Marc4R::MarcException.new("subfield code must be a single character #{slice.inspect}")
      end
      @subfields << Marc4R::Fields::Subfield.new(*slice)
    end
  end

  def subfields(code=nil)
  	code ? @subfields.select {|sf| sf.code == code} : @subfields
  end

  def subfield(code=nil)
  	subfields(code).first
  end

  def =~ pattern
    subfields.detect {|f| f =~ pattern}
  end

  def eql? other
    if other.is_a? Marc4R::Fields::DataField
      r = self.tag.eql? other.tag
      r &= self.indicator1.eql? other.indicator1
      r &= self.indicator2.eql? other.indicator2
      r &= self.subfields.size.eql? other.subfields.size
      if r
        self.subfields.each do |sf|
          r &= other.subfields.detect {|osf| (osf.code.eql? sf.code) && (osf.data.eql? sf.data)}
        end
      end
      r
    else
      false
    end
  end
end