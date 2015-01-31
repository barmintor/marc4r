require 'spec_helper'

describe Marc4R::Fields::DataField do
  subject {Marc4R::Fields::DataField.new("245", '1', '0')}
  describe '#initialize' do
    it 'should set the tag and indicators' do
      expect(subject.tag).to eql("245")
      expect(subject.indicator1).to eql("1")
      expect(subject.indicator2).to eql("0")
    end
  end
  describe '#subfields' do
    let(:subfield_a) { Marc4R::Fields::Subfield.new('a', "Summerland")}
  	let(:subfield_c) { Marc4R::Fields::Subfield.new('c', "Michael Chabon")}
  	it "should initially be empty" do
  	  expect(subject.subfields).to be_empty
  	end
    context 'with a subfield' do
      it "should append a subfield" do
        subject.subfields << subfield_a
        expect(subject.subfields.size).to eql(1)
        subject.subfields.insert(0, subfield_c)
        expect(subject.subfields.size).to eql(2)
        expect(subject.subfields.last.code).to eql('a')
        expect(subject =~ /^Summer/).to be
        expect(subject =~ /^ummer/).not_to be
      end
    end
  end
  describe '<=>' do
    let(:before) {Marc4R::Fields::ControlField.new('240')}
    let(:after) {Marc4R::Fields::ControlField.new('300')}
    it "should sort appropriately" do
      expect(subject <=> before).to eql(1)
      expect(subject <=> after).to eql(-1)
      expect(subject <=> subject).to eql(0)
    end
  end
end