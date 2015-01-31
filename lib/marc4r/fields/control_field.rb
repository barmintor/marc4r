class Marc4R::Fields::ControlField
  include Marc4R::Fields::Idable
  include Marc4R::Fields::Taggable
  include Marc4R::Fields::Datable
  def initialize(tag=nil,data=nil)
    self.tag= tag if tag
    self.data= data if data
  end
  def self.accepts_tag(tag)
    tag =~ /^00[0-9]$/
  end
  def eql? o
  	if o.is_a? Marc4R::Fields::ControlField
      (self.tag.eql? o.tag) && (self.data.eql? o.data)
    else
      false
    end
  end
end