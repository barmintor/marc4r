require 'spec_helper'

describe Marc4R::Record do
  subject do
    sumland = Marc4R::Record.new("00714cam a2200205 a 4500");
    sumland.control_fields << Marc4R::Fields::ControlField.new("001", "12883376")
    sumland.control_fields << Marc4R::Fields::ControlField.new("005", "20030616111422.0")
    sumland.control_fields << Marc4R::Fields::ControlField.new("008", "020805s2002    nyu    j      000 1 eng  ")
    sumland.data_fields << Marc4R::Fields::DataField.new("020", ' ', ' ', "a", "0786808772")
    sumland.data_fields << Marc4R::Fields::DataField.new("020", ' ', ' ', "a", "0786816155 (pbk.)")
    sumland.data_fields << Marc4R::Fields::DataField.new("040", ' ', ' ', "a", "DLC", "c", "DLC", "d", "DLC")
    sumland.data_fields << Marc4R::Fields::DataField.new("100", '1', ' ', "a", "Chabon, Michael.")
    sumland.data_fields << Marc4R::Fields::DataField.new("245", '1', '0', "a", "Summerland /", "c", "Michael Chabon.")
    sumland.data_fields << Marc4R::Fields::DataField.new("250", ' ', ' ', "a", "1st ed.")
    sumland.data_fields << Marc4R::Fields::DataField.new("260", ' ', ' ', "a", "New York :", "b", "Miramax Books/Hyperion Books for Children,", "c", "c2002.")
    sumland.data_fields << Marc4R::Fields::DataField.new("300", ' ', ' ', "a", "500 p. ;", "c", "22 cm.")
    sumland.data_fields << Marc4R::Fields::DataField.new("520", ' ', ' ', "a", "Ethan Feld, the worst baseball player in the history of the game, finds himself recruited by a 100-year-old scout to help a band of fairies triumph over an ancient enemy.")
    sumland.data_fields << Marc4R::Fields::DataField.new("650", ' ', '1', "a", "Fantasy.")
    sumland.data_fields << Marc4R::Fields::DataField.new("650", ' ', '1', "a", "Baseball", "v", "Fiction.")
    sumland.data_fields << Marc4R::Fields::DataField.new("650", ' ', '1', "a", "Magic", "v", "Fiction.")
    sumland
  end
  describe '#initialize' do
    it "should assign the leader from a String argument" do
      expect(subject.leader.to_s).to eql('00714cam a2200205 a 4500')
      expect(subject.leader.record_length).to eql(714)
    end
  end
  describe '#control_fields' do
    it do
      expect(subject.control_number).to eql("12883376")
      cf = subject.control_number_field
      expect(cf.tag).to eql("001")
      expect(cf.data).to eql("12883376")
      expect(subject.control_fields.size).to eql(3)
    end
  end
  describe '#data_fields' do
    it do
      expect(subject.data_fields.size).to eql(12)
      expect(subject.data_fields('650').size).to eql(3)
      expect(subject.data_fields("245", "260", "300").size).to eql(3)
    end
  end
  describe '#variable_fields' do
    pending 'decision about preserving variable_fields syntax' do
      expect(subject.variable_fields.size).to eql(15)
    end
  end
  describe '#find' do
    it do
      result = subject.find(/Summerland/);
      expect(result.size).to eql(1)
      field = result.first;
      expect(field.tag).to eql("245")

      result = subject.find(/Chabon/);
      expect(result.size).to eql(2)

      result = subject.find("100", /Chabon/);
      expect(result.size).to eql(1)

      result = subject.find("100", "260", "300", /Chabon/);
      expect(result.size).to eql(1)

      result = subject.find("040", /DLC/);
      expect(result.size).to be > 0
    end
  end

  describe Marc4R::Record::Leader do
    let(:empty) {Marc4R::Record::Leader.new}
    let(:assigned) {Marc4R::Record::Leader.new('00714cam a2200205 a 4500')}
    describe '#initialize' do
      it "should set a string value appropriately" do
        expect(empty.to_s).to eql('')
        expect(assigned.to_s).to eql('00714cam a2200205 a 4500')
        test = Marc4R::Record::Leader.new('00759cam a2200229 a 4500')
        expect(test.to_s).to eql("00759cam a2200229 a 4500")
      end
      it "should parse the leader correctly" do
        expect(assigned.record_length).to eql(714)
        expect(assigned.record_status).to eql('c')
        expect(assigned.record_type).to eql('a')
        expect(assigned.impl_defined1).to eql(['m',' '])
        expect(assigned.char_coding_scheme).to eql('a')
        expect(assigned.indicator_count).to eql(2)
        expect(assigned.subfield_code_count).to eql(2)
        expect(assigned.data_base_address).to eql(205)
        expect(assigned.impl_defined2).to eql([' ','a'])
        expect(assigned.entry_map).to eql([' ','4','5','0','0'])
      end
    end
    describe 'fields accessors' do
      it do
        test = Marc4R::Record::Leader.new(assigned.to_s)
        test.subfield_code_count= 1
        test.record_length = 9417
        test.data_base_address = 37
        expect(test.to_s).to eql('09417cam a2100037 a 4500')
      end
    end
    describe '#eql?' do
      it "should compare appropriately" do
        expect(empty.eql? Marc4R::Record::Leader.new).to be
        expect(assigned.eql? Marc4R::Record::Leader.new('00714cam a2200205 a 4500')).to be
        expect(assigned.eql? empty).not_to be
      end
    end
  end
end