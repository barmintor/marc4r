# -*- encoding: utf-8 -*-
module Marc4R
  MARCXML_NS_URI = "http://www.loc.gov/MARC21/slim"
  autoload :Fields, 'marc4r/fields'
  autoload :Record, 'marc4r/record'
  autoload :MarcStreamReader, 'marc4r/marc_stream_reader'
  module Terminators
  	RECORD_TERMINATOR = "\x1D"
  	FIELD_TERMINATOR = "\x1E"
  	SUBFIELD_TERMINATOR = "\x1F"
  	BLANK = "\x20"
  end
  module Encodings
    # MARC-8 ANSEL ENCODING
    MARC_8_ENCODING = "MARC8"

    # ISO5426 ENCODING
    ISO5426_ENCODING = "ISO5426"

    # ISO6937 ENCODING
    ISO6937_ENCODING = "ISO6937"    
  end
  class MarcException < Exception; end
end