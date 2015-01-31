class Marc4R::Fields::Subfield
  include Marc4R::Fields::Idable
  include Marc4R::Fields::Datable
  attr_accessor :code
  def initialize(code=nil, data=nil)
    self.code = code if code
    self.data = data if data
  end
  def to_s
    "#{code}#{data}"
  end
end