require 'rspec'
require_relative 'password'

RSpec.describe Password do
  subject { Password.new(code) }

  describe "#valid?" do
    context "with a never-decreasing code, with a double" do
      let(:code) { 111111 }

      it "is valid" do
        expect(subject.valid?).to be(true)
      end
    end

    context "with a decreasing code" do
      let(:code) { 223450 }

      it "is not valid" do
        expect(subject.valid?).to be(false)
      end
    end

    context "without a double" do
      let(:code) { 123789 }

      it "is not valid" do
        expect(subject.valid?).to be(false)
      end
    end
  end

  describe "#still_valid?" do
    context "with only doubles" do
      let(:code) { 112233 }

      it "is valid" do
        expect(subject.still_valid?).to be(true)
      end
    end

    context "with only a triple" do
      let(:code) { 123444 }

      it "is not valid" do
        expect(subject.still_valid?).to be(false)
      end
    end

    context "with a double and a quad" do
      let(:code) { 111122 }

      it "is valid" do
        expect(subject.still_valid?).to be(true)
      end
    end
  end
end
