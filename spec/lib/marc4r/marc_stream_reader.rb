require 'spec_helper'

describe Marc4R::MarcStreamReader do
  let(:input) {fixture(TestConstants::RESOURCES_CHABON_MRC)}
  describe "#each" do
    subject {Marc4R::MarcStreamReader.new(input).lazy}
    it "should enumerate over expected MARC records" do
      first = subject.take(1).first
      expect(first).not_to be_nil
      validateKavalieAndClayRecord(first)
      second = subject.take(1).first
      expect(second).not_to be_nil
      validateSummerlandRecord(second)
      # there's only two records in this stream
      expect(subject.take(1).first).to be_nil
      input.close
    end
  end
end