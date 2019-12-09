require 'rspec'
require_relative 'wires'

RSpec.describe Point do
  subject { Point.new(x, y) }

  describe "#manhattan_distance" do
    let(:x) { 4 }
    let(:y) { -2 }

    it "should be the distance from origin" do
      expect(subject.manhattan_distance).to eq(6)
    end
  end
end

RSpec.describe Wire do
  subject { Wire.new(%w[R2 U2 L4 D4]) }

  describe "#points" do
    it "should return a list of points the route takes" do
      expect(subject.points).to eq([
        Point.new(0, 0),
        Point.new(1, 0),
        Point.new(2, 0),
        Point.new(2, 1),
        Point.new(2, 2),
        Point.new(1, 2),
        Point.new(0, 2),
        Point.new(-1, 2),
        Point.new(-2, 2),
        Point.new(-2, 1),
        Point.new(-2, 0),
        Point.new(-2, -1),
        Point.new(-2, -2),
      ])
    end
  end

  describe "#&" do
    let(:other_wire) { Wire.new(%w[U3 R1 D5]) }

    it "should return the points where the wires cross, excluding the origin, sorted bytheir manhattan distance from the origin" do
      expect(subject & other_wire).to eq([
        Point.new(1, 0),
        Point.new(0, 2),
        Point.new(1, 2),
      ])
    end
  end
end

RSpec.describe '#closest_crossing' do
  subject { closest_crossing(wire1, wire2) }

  context "example 1" do
    let(:wire1) { %w[R8 U5 L5 D3] }
    let(:wire2) { %w[U7 R6 D4 L4] }

    it { is_expected.to eq(6) }
  end

  context "example 2" do
    let(:wire1) { %w[R75 D30 R83 U83 L12 D49 R71 U7 L72] }
    let(:wire2) { %w[U62 R66 U55 R34 D71 R55 D58 R83] }

    it { is_expected.to eq(159) }
  end

  context "example 3" do
    let(:wire1) { %w[R98 U47 R26 D63 R33 U87 L62 D20 R33 U53 R51] }
    let(:wire2) { %w[U98 R91 D20 R16 D67 R40 U7 R15 U6 R7] }

    it { is_expected.to eq(135) }
  end
end
