require 'rspec'
require_relative 'intcode'

RSpec.describe '#run_opcode' do
  subject { run_opcode(data, index) }

  context "for opcode 1" do
    let(:data) { [1, 2, 3, 3] }
    let(:index) { 0 }

    it "adds the data" do
      is_expected.to eq([1, 2, 3, 6])
    end
  end

  context "for opcode 2" do
    let(:data) { [2, 2, 3, 3] }
    let(:index) { 0 }

    it "multiplies the data" do
      is_expected.to eq([2, 2, 3, 9])
    end
  end

  context "for opcode 99" do
    let(:data) { [99, 2, 3, 3] }
    let(:index) { 0 }

    it "returns false" do
      is_expected.to be(false)
    end
  end

  context "for any other opcode" do
    let(:data) { [42, 2, 3, 3] }
    let(:index) { 0 }

    it "raises an UnknownOpcode error" do
      expect { subject }.to raise_error(UnknownOpcode)
    end
  end
end

RSpec.describe '#run_intcode' do
  subject { run_intcode(data) }

  context "example one" do
    let(:data) { [
      1, 9, 10, 3,
      2, 3, 11, 0,
      99,
      30, 40, 50
    ] }

    it { is_expected.to eq([
      3500, 9, 10, 70,
      2, 3, 11, 0,
      99,
      30, 40, 50
    ])
    }
  end

  context "example two" do
    let(:data) { [1,0,0,0,99] }
    it { is_expected.to eq([2,0,0,0,99]) }
  end

  context "example three" do
    let(:data) { [2,3,0,3,99] }
    it { is_expected.to eq([2,3,0,6,99]) }
  end

  context "example four" do
    let(:data) { [2,4,4,5,99,0] }
    it { is_expected.to eq([2,4,4,5,99,9801]) }
  end

  context "example five" do
    let(:data) { [1,1,1,4,99,5,6,0,99] }
    it { is_expected.to eq([30,1,1,4,2,5,6,0,99]) }
  end
end
