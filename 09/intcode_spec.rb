require 'ostruct'
require 'rspec'
require_relative 'intcode'

RSpec.describe "#addition_opcode" do
  subject { IntcodeComputer.new(data) }
  let(:data) { [1001, 4, 3, 4, 96] }

  it "should move the index pointer forwards to the next instruction" do
    subject.step
    expect(subject.index).to eq(4)
  end

  it "should modify the data" do
    subject.step
    expect(subject.intcode).to eq([1001, 4, 3, 4, 99])
  end
end

RSpec.describe "#multiplication_opcode" do
  subject { IntcodeComputer.new(data) }
  let(:data) { [1002, 4, 3, 4, 33] }

  it "should move the index pointer forwards to the next instruction" do
    subject.step
    expect(subject.index).to eq(4)
  end

  it "should modify the data" do
    subject.step
    expect(subject.intcode).to eq([1002, 4, 3, 4, 99])
  end
end

RSpec.describe "#halt_opcode" do
  subject { IntcodeComputer.new(data) }
  let(:data) { [99] }

  it "set the state to HALTED" do
    subject.step
    expect(subject.state).to eq(IntcodeComputer::HALTED)
  end

  it "leave data unchanged" do
    subject.step
    expect(subject.intcode).to eq([99])
  end
end

RSpec.describe "#input_opcode" do
  subject { IntcodeComputer.new(data) }
  let(:data) { [3,2,0] }

  it "should move the index pointer forwards to the next instruction" do
    subject.provide_input(99)
    subject.step
    expect(subject.index).to eq(2)
  end

  it "should copy from the input" do
    subject.provide_input(99)
    subject.step
    expect(subject.intcode).to eq([3,2,99])
  end

  it "should pause if it doesn't have input" do
    subject.step
    expect(subject.state).to eq(IntcodeComputer::PAUSED)
  end
end

RSpec.describe "#output_opcode" do
  subject { IntcodeComputer.new(data) }
  let(:data) { [4,2,99] }

  it "should move the index pointer forwards to the next instruction" do
    subject.step
    expect(subject.index).to eq(2)
  end

  it "should write to the output" do
    subject.step
    expect(subject.get_output).to eq(99)
  end

  context "with an immediate parameter" do
    let(:data) { [104,2,99] }

    it "should write to the output" do
      subject.step
      expect(subject.get_output).to eq(2)
    end
  end
end

RSpec.describe "#jump_if_true_opcode" do
  subject { IntcodeComputer.new(data) }

  context "with a position parameter" do
    let(:data) { [5, 2, 1, 99] }

    it "checks the value at the index given, and jumps to the index at the index given" do
      subject.step
      expect(subject.index).to eq(2)
    end

    it "leaves data unchanged" do
      subject.step
      expect(subject.intcode).to eq([5, 2, 1, 99])
    end
  end

  context "when the parameter is true" do
    let(:data) { [1105, 1, 4, 99, 99] }

    it "jumps to the index given" do
      subject.step
      expect(subject.index).to eq(4)
    end
  end

  context "when the parameter is false" do
    let(:data) { [1105, 0, 4, 99, 99] }

    it "should move the index pointer forwards to the next instruction" do
      subject.step
      expect(subject.index).to eq(3)
    end
  end
end

RSpec.describe "#jump_if_false_opcode" do
  subject { IntcodeComputer.new(data) }

  context "with a position parameter" do
    let(:data) { [6, 2, 0, 99, 99, 99] }

    it "checks the value at the index given, and jumps to the index at the index given" do
      subject.step
      expect(subject.index).to eq(6)
    end

    it "leaves data unchanged" do
      subject.step
      expect(subject.intcode).to eq([6, 2, 0, 99, 99, 99])
    end
  end

  context "when the parameter is false" do
    let(:data) { [1106, 0, 4, 99, 99] }

    it "jumps to the index given" do
      subject.step
      expect(subject.index).to eq(4)
    end
  end

  context "when the parameter is true" do
    let(:data) { [1106, 1, 4, 99, 99] }

    it "should move the index pointer forwards to the next instruction" do
      subject.step
      expect(subject.index).to eq(3)
    end
  end
end

RSpec.describe "#less_than_opcode" do
  subject { IntcodeComputer.new(data) }

  context "with position parameters" do
    let(:data) { [7, 4, 5, 5, 99, 100] }

    it "compares the values at the indexes given" do
      subject.step
      expect(subject.intcode).to eq([7, 4, 5, 5, 99, 1])
    end

    it "should move the index pointer forwards to the next instruction" do
      subject.step
      expect(subject.index).to eq(4)
    end
  end

  context "when the first parameter is less than the second" do
    let(:data) { [1107, 41, 42, 0, 99] }

    it "writes a one" do
      subject.step
      expect(subject.intcode).to eq([1, 41, 42, 0, 99])
    end

    it "should move the index pointer forwards to the next instruction" do
      subject.step
      expect(subject.index).to eq(4)
    end
  end

  context "when the first parameter is not less than the second" do
    let(:data) { [1107, 42, 42, 0, 99] }

    it "writes a zero" do
      subject.step
      expect(subject.intcode).to eq([0, 42, 42, 0, 99])
    end

    it "should move the index pointer forwards to the next instruction" do
      subject.step
      expect(subject.index).to eq(4)
    end
  end
end

RSpec.describe "#equals_opcode" do
  subject { IntcodeComputer.new(data) }

  context "with position parameters" do
    let(:data) { [8, 4, 5, 5, 99, 99] }

    it "compares the values at the indexes given" do
      subject.step
      expect(subject.intcode).to eq([8, 4, 5, 5, 99, 1])
    end

    it "should move the index pointer forwards to the next instruction" do
      subject.step
      expect(subject.index).to eq(4)
    end
  end

  context "when the parameters match" do
    let(:data) { [1108, 42, 42, 0, 99] }

    it "writes a one" do
      subject.step
      expect(subject.intcode).to eq([1, 42, 42, 0, 99])
    end

    it "should move the index pointer forwards to the next instruction" do
      subject.step
      expect(subject.index).to eq(4)
    end
  end

  context "when the parameters do not match" do
    let(:data) { [1108, 42, 69, 0, 99] }

    it "writes a zero" do
      subject.step
      expect(subject.intcode).to eq([0, 42, 69, 0, 99])
    end

    it "should move the index pointer forwards to the next instruction" do
      subject.step
      expect(subject.index).to eq(4)
    end
  end
end

RSpec.describe "#adjust_relative_base_opcode" do
  subject { IntcodeComputer.new(data) }
  let(:data) { [9,2,99] }

  it "should move the index pointer forwards to the next instruction" do
    subject.step
    expect(subject.index).to eq(2)
  end

  it "adjust the relative base" do
    subject.step
    expect(subject.relative_base).to eq(99)
  end

  context "with an immediate parameter" do
    let(:data) { [109,2,99] }

    it "adjust the relative base" do
      subject.step
      expect(subject.relative_base).to eq(2)
    end
  end
end

RSpec.describe '#run_intcode' do
  let(:computer) { IntcodeComputer.new(data) }
  subject { computer.run; computer.intcode }

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
    let(:value) { double(:value) }

    it "should output whatever it gets as input, and halt" do
      computer.provide_input(value)
      computer.run
      expect(computer.get_output).to be(value)
    end
  end
end
