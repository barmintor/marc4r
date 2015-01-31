require 'spec_helper'

describe Marc4R::Fields::ControlField do
  subject {Marc4R::Fields::ControlField.new('008','foo')}
  describe '#initialize' do
    it 'should set the tag' do
      expect(subject.tag).to eql("008")
    end
    it 'should set the data' do
      expect(subject.data).to eql("foo")
    end
  end
  context 'accessors' do
    subject {Marc4R::Fields::ControlField.new()}
    describe '#data=' do
      it 'should set the data' do
        expect(subject.data).to be_nil
        subject.data = 'foo'
        expect(subject.data).to eql("foo")
      end
    end
    describe '#tag=' do
      it 'should set the tag' do
        expect(subject.tag).to be_nil
        subject.tag = 'foo'
        expect(subject.tag).to eql("foo")
      end
    end
  end
  describe '#=~' do
    it "should match on data" do
      subject.data = 'foo'
      expect(subject =~ /^foo/).to be_truthy
      expect(subject =~ /^oo/).to be_falsy
    end
  end
  describe '<=>' do
    let(:before) {Marc4R::Fields::ControlField.new('007')}
    let(:after) {Marc4R::Fields::ControlField.new('009')}
    it "should sort appropriately" do
      expect(subject <=> before).to eql(1)
      expect(subject <=> after).to eql(-1)
      expect(subject <=> subject).to eql(0)
    end
  end
end