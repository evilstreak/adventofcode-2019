require 'ostruct'
require 'rspec'
require_relative 'intcode'

RSpec.describe "#extract_parameter_modes" do
  subject { extract_parameter_modes(opcode_instruction, parameter_count) }

  context "for a single immediate parameter" do
    let(:opcode_instruction) { 104 }
    let(:parameter_count) { 1 }

    it { is_expected.to eq([1]) }
  end

  context "for a single position parameter" do
    let(:opcode_instruction) { 4 }
    let(:parameter_count) { 1 }

    it { is_expected.to eq([0]) }
  end

  context "for multiple mixed parameters" do
    let(:opcode_instruction) { 1102 }
    let(:parameter_count) { 3 }

    it { is_expected.to eq([1, 1, 0]) }
  end
end

RSpec.describe "#addition_opcode" do
  subject { addition_opcode(data, index, input, output) }
  let(:data) { [1002, 4, 3, 4, 96] }
  let(:index) { 0 }
  let(:input) { :input }
  let(:output) { :output }

  it "should move the index pointer forwards to the next instruction" do
    new_index = subject
    expect(new_index).to eq(4)
  end

  it "should modify the data" do
    subject

    expect(data).to eq([1002, 4, 3, 4, 99])
  end
end

RSpec.describe "#multiplication_opcode" do
  subject { multiplication_opcode(data, index, input, output) }
  let(:data) { [1002, 4, 3, 4, 33] }
  let(:index) { 0 }
  let(:input) { :input }
  let(:output) { :output }

  it "should move the index pointer forwards to the next instruction" do
    new_index = subject
    expect(new_index).to eq(4)
  end

  it "should modify the data" do
    subject

    expect(data).to eq([1002, 4, 3, 4, 99])
  end
end

RSpec.describe "#halt_opcode" do
  subject { halt_opcode(data, index, input, output) }
  let(:data) { [99] }
  let(:index) { 0 }
  let(:input) { :input }
  let(:output) { :output }

  it "set the index to -1" do
    new_index = subject
    expect(new_index).to eq(-1)
  end

  it "leave data unchanged" do
    subject

    expect(data).to eq([99])
  end
end

RSpec.describe "#input_opcode" do
  subject { input_opcode(data, index, input, output) }
  let(:data) { [3,2,0] }
  let(:index) { 0 }
  let(:input) { OpenStruct.new(call: 99) }
  let(:output) { :output }

  it "should move the index pointer forwards to the next instruction" do
    new_index = subject
    expect(new_index).to eq(2)
  end

  it "should copy from the input" do
    subject

    expect(data).to eq([3,2,99])
  end
end

RSpec.describe "#output_opcode" do
  subject { output_opcode(data, index, input, output) }
  let(:data) { [4,2,99] }
  let(:index) { 0 }
  let(:input) { :input }
  let(:output) { double(:output) }

  it "should move the index pointer forwards to the next instruction" do
    expect(output).to receive(:call).with(99)

    new_index = subject
    expect(new_index).to eq(2)
  end

  it "should write to the output" do
    expect(output).to receive(:call).with(99)

    subject
  end

  context "with an immediate parameter" do
    let(:data) { [104,2,99] }

    it "should write to the output" do
      expect(output).to receive(:call).with(2)

      subject
    end
  end
end

RSpec.describe "#jump_if_true_opcode" do
  subject { jump_if_true_opcode(data, index, input, output) }
  let(:index) { 0 }
  let(:input) { :input }
  let(:output) { :output }

  context "with a position parameter" do
    let(:data) { [5, 2, 1, 99] }

    it "checks the value at the index given, and jumps to the index at the index given" do
      expect(subject).to eq(2)
    end

    it "leaves data unchanged" do
      subject

      expect(data).to eq([5, 2, 1, 99])
    end
  end

  context "when the parameter is true" do
    let(:data) { [1105, 1, 4, 99, 99] }

    it "jumps to the index given" do
      expect(subject).to eq(4)
    end
  end

  context "when the parameter is false" do
    let(:data) { [1105, 0, 4, 99, 99] }

    it "should move the index pointer forwards to the next instruction" do
      expect(subject).to eq(3)
    end
  end
end

RSpec.describe "#jump_if_false_opcode" do
  subject { jump_if_false_opcode(data, index, input, output) }
  let(:index) { 0 }
  let(:input) { :input }
  let(:output) { :output }

  context "with a position parameter" do
    let(:data) { [5, 2, 0, 99, 99] }

    it "checks the value at the index given, and jumps to the index at the index given" do
      expect(subject).to eq(5)
    end

    it "leaves data unchanged" do
      subject

      expect(data).to eq([5, 2, 0, 99, 99])
    end
  end

  context "when the parameter is false" do
    let(:data) { [1105, 0, 4, 99, 99] }

    it "jumps to the index given" do
      expect(subject).to eq(4)
    end
  end

  context "when the parameter is true" do
    let(:data) { [1105, 1, 4, 99, 99] }

    it "should move the index pointer forwards to the next instruction" do
      expect(subject).to eq(3)
    end
  end
end

RSpec.describe "#less_than_opcode" do
  subject { less_than_opcode(data, index, input, output) }
  let(:index) { 0 }
  let(:input) { :input }
  let(:output) { :output }

  context "with position parameters" do
    let(:data) { [7, 4, 5, 5, 99, 100] }

    it "compares the values at the indexes given" do
      subject

      expect(data).to eq([7, 4, 5, 5, 99, 1])
    end

    it "should move the index pointer forwards to the next instruction" do
      expect(subject).to eq(4)
    end
  end

  context "when the first parameter is less than the second" do
    let(:data) { [1107, 41, 42, 0, 99] }

    it "writes a one" do
      subject

      expect(data).to eq([1, 41, 42, 0, 99])
    end

    it "should move the index pointer forwards to the next instruction" do
      expect(subject).to eq(4)
    end
  end

  context "when the first parameter is not less than the second" do
    let(:data) { [1107, 42, 42, 0, 99] }

    it "writes a zero" do
      subject

      expect(data).to eq([0, 42, 42, 0, 99])
    end

    it "should move the index pointer forwards to the next instruction" do
      expect(subject).to eq(4)
    end
  end
end

RSpec.describe "#equals_opcode" do
  subject { equals_opcode(data, index, input, output) }
  let(:index) { 0 }
  let(:input) { :input }
  let(:output) { :output }

  context "with position parameters" do
    let(:data) { [8, 4, 5, 5, 99, 99] }

    it "compares the values at the indexes given" do
      subject

      expect(data).to eq([8, 4, 5, 5, 99, 1])
    end

    it "should move the index pointer forwards to the next instruction" do
      expect(subject).to eq(4)
    end
  end

  context "when the parameters match" do
    let(:data) { [1108, 42, 42, 0, 99] }

    it "writes a one" do
      subject

      expect(data).to eq([1, 42, 42, 0, 99])
    end

    it "should move the index pointer forwards to the next instruction" do
      expect(subject).to eq(4)
    end
  end

  context "when the parameters do not match" do
    let(:data) { [1108, 42, 69, 0, 99] }

    it "writes a zero" do
      subject

      expect(data).to eq([0, 42, 69, 0, 99])
    end

    it "should move the index pointer forwards to the next instruction" do
      expect(subject).to eq(4)
    end
  end
end

RSpec.describe '#run_intcode' do
  subject { run_intcode(data, input, output) }
  let(:input) { :input }
  let(:output) { :output }

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

  context "example six" do
    let(:data) { [3,0,4,0,99] }
    let(:input) { double(:input) }
    let(:output) { double(:output) }
    let(:value) { double(:value) }

    it "should output whatever it gets as input, and halt" do
      expect(input).to receive(:call).and_return(value)
      expect(output).to receive(:call).with(value)

      expect(subject).to eq([value,0,4,0,99])
    end
  end
end
