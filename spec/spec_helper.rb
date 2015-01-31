require "bundler/setup"

require 'rspec/its'
require 'rspec/matchers'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.command_name "spec"
end
require 'marc4r'
require 'test_constants'
#$in_travis = !ENV['TRAVIS'].nil? && ENV['TRAVIS'] == 'true'
RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

end

def fixture(name, &block)
  filename = File.expand_path("../fixtures/#{name}", __FILE__)
  if block_given?
    open(filename) &block
  else
    open(filename)
  end
end

def fixture_data(name)
  fixture(name) {|io| io.read}
end

RSpec::Matchers.define :be_control_field do |expected|
  match do |actual|
    tag = expected[0]
    data = expected[1]
    r = actual.is_a? Marc4R::Fields::ControlField
    r &= actual.tag == tag
    r &= actual.data = data
  end
end

  def validateKavalieAndClayRecord(record)
    expect(record.leader.to_s).to eql("00759cam a2200229 a 4500")
    expect(record.control_fields.size).to eql(3)
    expect(record.data_fields.size).to eql(14)
    expect(record.control_fields[0]).to eql(Marc4R::Fields::ControlField.new("001","11939876"))
    expect(record.control_fields[1]).to eql(Marc4R::Fields::ControlField.new("005", "20041229190604.0"))
    expect(record.control_fields[2]).to eql(Marc4R::Fields::ControlField.new("008", "000313s2000    nyu           000 1 eng  "))
    expect(record.data_fields[0]).to eql(Marc4R::Fields::DataField.new("020", ' ', ' ', "a", "0679450041 (acid-free paper)"))
    expect(record.data_fields[1]).to eql(Marc4R::Fields::DataField.new("040", ' ', ' ', "a", "DLC", "c", "DLC", "d", "DLC"))
    expect(record.data_fields[2]).to eql(Marc4R::Fields::DataField.new("100", '1', ' ', "a", "Chabon, Michael."))
    expect(record.data_fields[3]).to eql(Marc4R::Fields::DataField.new("245", '1', '4', "a", "The amazing adventures of Kavalier and Clay :", "b", "a novel /", "c", "Michael Chabon."))
    expect(record.data_fields[4]).to eql(Marc4R::Fields::DataField.new("260", ' ', ' ', "a", "New York :", "b", "Random House,", "c", "c2000."))
    expect(record.data_fields[5]).to eql(Marc4R::Fields::DataField.new("300", ' ', ' ', "a", "639 p. ;", "c", "25 cm."))
    expect(record.data_fields[6]).to eql(Marc4R::Fields::DataField.new("650", ' ', '0', "a", "Comic books, strips, etc.", "x", "Authorship", "v", "Fiction."))
    expect(record.data_fields[7]).to eql(Marc4R::Fields::DataField.new("650", ' ', '0', "a", "Heroes in mass media", "v", "Fiction."))
    expect(record.data_fields[8]).to eql(Marc4R::Fields::DataField.new("650", ' ', '0', "a", "Czech Americans", "v", "Fiction."))
    expect(record.data_fields[9]).to eql(Marc4R::Fields::DataField.new("651", ' ', '0', "a", "New York (N.Y.)", "v", "Fiction."))
    expect(record.data_fields[10]).to eql(Marc4R::Fields::DataField.new("650", ' ', '0', "a", "Young men", "v", "Fiction."))
    expect(record.data_fields[11]).to eql(Marc4R::Fields::DataField.new("650", ' ', '0', "a", "Cartoonists", "v", "Fiction."))
    expect(record.data_fields[12]).to eql(Marc4R::Fields::DataField.new("655", ' ', '7', "a", "Humorous stories.", "2", "gsafd"))
    expect(record.data_fields[13]).to eql(Marc4R::Fields::DataField.new("655", ' ', '7', "a", "Bildungsromane.", "2", "gsafd"))
  end


  def validateSummerlandRecord(record)
    expect(record.leader.to_s).to eql "00714cam a2200205 a 4500"
    expect(record.control_fields.size).to eql(3)
    expect(record.data_fields.size).to eql(12)
    expect(record.control_fields[0]).to eql(Marc4R::Fields::ControlField.new("001","12883376"))
    expect(record.control_fields[1]).to eql(Marc4R::Fields::ControlField.new("005", "20030616111422.0"))
    expect(record.control_fields[2]).to eql(Marc4R::Fields::ControlField.new("008", "020805s2002    nyu    j      000 1 eng  "))
    expect(record.data_fields[0]).to eql Marc4R::Fields::DataField.new("020", ' ', ' ', "a", "0786808772")
    expect(record.data_fields[1]).to eql Marc4R::Fields::DataField.new("020", ' ', ' ', "a", "0786816155 (pbk.)")
    expect(record.data_fields[2]).to eql Marc4R::Fields::DataField.new("040", ' ', ' ', "a", "DLC", "c", "DLC", "d", "DLC")
    expect(record.data_fields[3]).to eql Marc4R::Fields::DataField.new("100", '1', ' ', "a", "Chabon, Michael.")
    expect(record.data_fields[4]).to eql Marc4R::Fields::DataField.new("245", '1', '0', "a", "Summerland /", "c", "Michael Chabon.")
    expect(record.data_fields[5]).to eql Marc4R::Fields::DataField.new("250", ' ', ' ', "a", "1st ed.")
    expect(record.data_fields[6]).to eql Marc4R::Fields::DataField.new("260", ' ', ' ', "a", "New York :", "b", "Miramax Books/Hyperion Books for Children,", "c", "c2002.")
    expect(record.data_fields[7]).to eql Marc4R::Fields::DataField.new("300", ' ', ' ', "a", "500 p. ;", "c", "22 cm.")
    expect(record.data_fields[8]).to eql Marc4R::Fields::DataField.new("520", ' ', ' ', "a", "Ethan Feld, the worst baseball player in the history of the game, finds himself recruited by a 100-year-old scout to help a band of fairies triumph over an ancient enemy.")
    expect(record.data_fields[9]).to eql Marc4R::Fields::DataField.new("650", ' ', '1', "a", "Fantasy.")
    expect(record.data_fields[10]).to eql Marc4R::Fields::DataField.new("650", ' ', '1', "a", "Baseball", "v", "Fiction.")
    expect(record.data_fields[11]).to eql Marc4R::Fields::DataField.new("650", ' ', '1', "a", "Magic", "v", "Fiction.")
  end

  def validateFreewheelingBobDylanRecord(record)
    assertEquals("leader", "01471cjm a2200349 a 4500", record.getLeader().marshal())
    expect(record.leader.to_s).to eql "00714cam a2200205 a 4500"
    expect(record.control_fields.size).to eql(4)
    expect(record.control_fields[0]).to eql(Marc4R::Fields::ControlField.new("001","5674874"))
    expect(record.control_fields[1]).to eql(Marc4R::Fields::ControlField.new("005", "20030305110405.0"))
    expect(record.control_fields[2]).to eql(Marc4R::Fields::ControlField.new("007", "sdubsmennmplu"))
    expect(record.control_fields[3]).to eql(Marc4R::Fields::ControlField.new("008", "930331s1963    nyuppn              eng d"))
    expect(record.data_fields.size).to eql(24)
    expect(record.data_fields[0]).to eql Marc4R::Fields::DataField.new("035", ' ', ' ', "9", "(DLC)   93707283")
    expect(record.data_fields[1]).to eql Marc4R::Fields::DataField.new("906", ' ', ' ', "a", "7", "b", "cbc", "c", "copycat", "d", "4", "e", "ncip", "f", "19", "g", "y-soundrec")
    expect(record.data_fields[2]).to eql Marc4R::Fields::DataField.new("010", ' ', ' ', "a", "   93707283 ")
    expect(record.data_fields[3]).to eql Marc4R::Fields::DataField.new("028", '0', '2', "a", "CS 8786", "b", "Columbia")
    expect(record.data_fields[4]).to eql Marc4R::Fields::DataField.new("035", ' ', ' ', "a", "(OCoLC)13083787")
    expect(record.data_fields[5]).to eql Marc4R::Fields::DataField.new("040", ' ', ' ', "a", "OClU", "c", "DLC", "d", "DLC")
    expect(record.data_fields[6]).to eql Marc4R::Fields::DataField.new("041", '0', ' ', "d", "eng", "g", "eng")
    expect(record.data_fields[7]).to eql Marc4R::Fields::DataField.new("042", ' ', ' ', "a", "lccopycat")
    expect(record.data_fields[8]).to eql Marc4R::Fields::DataField.new("050", '0', '0', "a", "Columbia CS 8786")
    expect(record.data_fields[9]).to eql Marc4R::Fields::DataField.new("100", '1', ' ', "a", "Dylan, Bob,", "d", "1941-")
    expect(record.data_fields[10]).to eql Marc4R::Fields::DataField.new("245", '1', '4', "a", "The freewheelin' Bob Dylan", "h", "[sound recording].")
    expect(record.data_fields[12]).to eql Marc4R::Fields::DataField.new("260", ' ', ' ', "a", "[New York, N.Y.] :", "b", "Columbia,", "c", "[1963]")
    expect(record.data_fields[13]).to eql Marc4R::Fields::DataField.new("300", ' ', ' ', "a", "1 sound disc :", "b", "analog, 33 1/3 rpm, stereo. ;", "c", "12 in.")
    expect(record.data_fields[14]).to eql Marc4R::Fields::DataField.new("500", ' ', ' ', "a", "Songs.")
    expect(record.data_fields[15]).to eql Marc4R::Fields::DataField.new("511", '0', ' ', "a", "The composer accompanying himself on the guitar ; in part with instrumental ensemble.")
    expect(record.data_fields[16]).to eql Marc4R::Fields::DataField.new("500", ' ', ' ', "a", "Program notes by Nat Hentoff on container.")
    expect(record.data_fields[17]).to eql Marc4R::Fields::DataField.new("505", '0', ' ', "a", "Blowin' in the wind -- Girl from the north country -- Masters of war -- Down the highway -- Bob Dylan's blues -- A hard rain's a-gonna fall -- Don't think twice, it's all right -- Bob Dylan's dream -- Oxford town -- Talking World War III blues -- Corrina, Corrina -- Honey, just allow me one more chance -- I shall be free.")
    expect(record.data_fields[18]).to eql Marc4R::Fields::DataField.new("650", ' ', '0', "a", "Popular music", "y", "1961-1970.")
    expect(record.data_fields[19]).to eql Marc4R::Fields::DataField.new("650", ' ', '0', "a", "Blues (Music)", "y", "1961-1970.")
    expect(record.data_fields[20]).to eql Marc4R::Fields::DataField.new("856", '4', '1', "3", "Preservation copy (limited access)", "u", "http://hdl.loc.gov/loc.mbrsrs/lp0001.dyln")
    expect(record.data_fields[21]).to eql Marc4R::Fields::DataField.new("952", ' ', ' ', "a", "New")
    expect(record.data_fields[22]).to eql Marc4R::Fields::DataField.new("953", ' ', ' ', "a", "TA28")
    expect(record.data_fields[23]).to eql Marc4R::Fields::DataField.new("991", ' ', ' ', "b", "c-RecSound", "h", "Columbia CS 8786", "w", "MUSIC")
  end