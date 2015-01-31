module Marc4R::Fields
  autoload :ControlField, 'marc4r/fields/control_field'
  autoload :DataField, 'marc4r/fields/data_field'
  autoload :Subfield, 'marc4r/fields/subfield'
  module Taggable
    attr_accessor :tag
    def <=>(compare)
      if compare.is_a? Marc4R::Fields::Taggable
        tag <=> compare.tag
      else
        super
      end
    end
  end
  module Datable
    attr_accessor :data
    def =~(pattern)
      if data
        data =~ pattern
      else
        nil
      end
    end
  end
  module Idable
    attr_accessor :id
  end
end