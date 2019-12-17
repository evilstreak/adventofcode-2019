require 'rspec'
require_relative 'asteroid'

RSpec.describe Point do
  describe '#points_exactly_between' do
    context 'with a point at the origin' do
      subject { Point.new(0, 0) }
      let(:other) { Point.new(3, 3) }

      it "should put all points between the subject and the other" do
        expect(subject.points_exactly_between(other)).to contain_exactly(
          Point.new(1, 1),
          Point.new(2, 2),
        )
      end
    end

    context 'with a point off the origin' do
      subject { Point.new(6, 4) }
      let(:other) { Point.new(9, 7) }

      it "should put all points between the subject and the other" do
        expect(subject.points_exactly_between(other)).to contain_exactly(
          Point.new(7, 5),
          Point.new(8, 6),
        )
      end
    end
 
    context 'with a point on an irregular line from' do
      subject { Point.new(0, 0) }
      let(:other) { Point.new(6, 3) }

      it "should put all points between the subject and the other" do
        expect(subject.points_exactly_between(other)).to contain_exactly(
          Point.new(2, 1),
          Point.new(4, 2),
        )
      end
    end

    context 'with a point in negative space' do
      subject { Point.new(-2, 2) }
      let(:other) { Point.new(-4, -6) }

      it "should put all points between the subject and the other" do
        expect(subject.points_exactly_between(other)).to contain_exactly(
          Point.new(-3, -2),
        )
      end
    end
  end

  describe '#angle_from' do
    subject { other.angle_from(Point.new(0, 0)) }

    context "with a point above" do
      let(:other) { Point.new(0, -1) }

      it { is_expected.to eq(0) }
    end

    context "with a point above and to the right" do
      let(:other) { Point.new(1, -1) }

      it { is_expected.to eq(1 * Math::PI / 4) }
    end

    context "with a point to the right" do
      let(:other) { Point.new(1, 0) }

      it { is_expected.to eq(2 * Math::PI / 4) }
    end

    context "with a point below and to the right" do
      let(:other) { Point.new(1, 1) }

      it { is_expected.to eq(3 * Math::PI / 4) }
    end

    context "with a point below" do
      let(:other) { Point.new(0, 1) }

      it { is_expected.to eq(4 * Math::PI / 4) }
    end

    context "with a point below and to the left" do
      let(:other) { Point.new(-1, 1) }

      it { is_expected.to eq(5 * Math::PI / 4) }
    end

    context "with a point to the left" do
      let(:other) { Point.new(-1, 0) }

      it { is_expected.to eq(6 * Math::PI / 4) }
    end

    context "with a point above and to the left" do
      let(:other) { Point.new(-1, -1) }

      it { is_expected.to eq(7 * Math::PI / 4) }
    end
  end
end

RSpec.describe Map do
  subject { Map.new(data) }

  describe "#asteroids_detectable_from" do
    let(:data) {
      <<~MAP
        .#..#
        .....
        #####
        ....#
        ...##
      MAP
    }

    it {
      expect(subject.asteroids_detectable_from(Point.new(3, 4)).count).to eq(8)
    }
  end

  describe "#best_monitoring_position" do
    context "example one" do
      let(:data) {
        <<~MAP
          .#..#
          .....
          #####
          ....#
          ...##
        MAP
      }

      it {
        expect(subject.best_monitoring_position).to eq(Point.new(3, 4))
      }
    end

    context "example two" do
      let(:data) {
        <<~MAP
          ......#.#.
          #..#.#....
          ..#######.
          .#.#.###..
          .#..#.....
          ..#....#.#
          #..#....#.
          .##.#..###
          ##...#..#.
          .#....####
        MAP
      }

      it {
        expect(subject.best_monitoring_position).to eq(Point.new(5, 8))
      }
    end

    context "example three" do
      let(:data) {
        <<~MAP
          #.#...#.#.
          .###....#.
          .#....#...
          ##.#.#.#.#
          ....#.#.#.
          .##..###.#
          ..#...##..
          ..##....##
          ......#...
          .####.###.
        MAP
      }

      it {
        expect(subject.best_monitoring_position).to eq(Point.new(1, 2))
      }
    end

    context "example four" do
      let(:data) {
        <<~MAP
          .#..#..###
          ####.###.#
          ....###.#.
          ..###.##.#
          ##.##.#.#.
          ....###..#
          ..#.#..#.#
          #..#.#.###
          .##...##.#
          .....#.#..
        MAP
      }

      it {
        expect(subject.best_monitoring_position).to eq(Point.new(6, 3))
      }
    end

    context "example five" do
      let(:data) {
        <<~MAP
          .#..##.###...#######
          ##.############..##.
          .#.######.########.#
          .###.#######.####.#.
          #####.##.#.##.###.##
          ..#####..#.#########
          ####################
          #.####....###.#.#.##
          ##.#################
          #####.##.###..####..
          ..######..##.#######
          ####.##.####...##..#
          .#####..#.######.###
          ##...#.##########...
          #.##########.#######
          .####.#.###.###.#.##
          ....##.##.###..#####
          .#.#.###########.###
          #.#.#.#####.####.###
          ###.##.####.##.#..##
        MAP
      }

      it {
        expect(subject.best_monitoring_position).to eq(Point.new(11, 13))
      }
    end
  end
end
