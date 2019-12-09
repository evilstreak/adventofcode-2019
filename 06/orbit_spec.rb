require 'ostruct'
require 'rspec'
require_relative 'orbit'

RSpec.describe SpaceObject do
  subject { SpaceObject.new(name, parent) }
  let(:name) { "BBB" }

  describe "#orbits" do
    context "with a parent with 1 orbit" do
      let(:parent) { OpenStruct.new(orbits: 1) }

      it "has 2 orbits (1 direct, 1 indirect)" do
        expect(subject.orbits).to be(2)
      end
    end

    context "with a parent with 5 orbit" do
      let(:parent) { OpenStruct.new(orbits: 5) }

      it "has 6 orbits (1 direct, 5 indirect)" do
        expect(subject.orbits).to be(6)
      end
    end
  end

  describe "#parents" do
    let(:com) { CenterOfMass.new }
    let(:intermediate) { SpaceObject.new("INT", com) }
    let(:parent) { SpaceObject.new("PAR", intermediate) }

    it "should return all the parents, in order of distance" do
      expect(subject.parents).to eq([
        parent,
        intermediate,
        com,
      ])
    end
  end

  describe "#closest_shared_parent" do
    let(:com) { CenterOfMass.new }
    let(:intermediate) { SpaceObject.new("INT", com) }
    let(:parent) { SpaceObject.new("PAR", intermediate) }
    let(:another_intermediate) { SpaceObject.new("ANO", intermediate) }
    let(:other) { SpaceObject.new("OTH", another_intermediate) }

    it "should return the first (closest) shared parent" do
      expect(subject.closest_shared_parent(other)).to eq(intermediate)
    end
  end

  describe "#distance_from" do
    let(:com) { CenterOfMass.new }
    let(:intermediate) { SpaceObject.new("INT", com) }
    let(:parent) { SpaceObject.new("PAR", intermediate) }
    let(:another_intermediate) { SpaceObject.new("ANO", intermediate) }
    let(:other) { SpaceObject.new("OTH", another_intermediate) }

    it "should return the distance between the objects" do
      expect(subject.distance_from(other)).to eq(2)
    end
  end
end

RSpec.describe OrbitMap do
  subject { OrbitMap.new(map_data) }

  describe "#initialize" do
    context "with unordered data" do
      let(:map_data) {
        %w[
          VM4)D
          COM)B
          B)VM4
        ]
      }

      it "should successfully initialise" do
        expect(subject.objects.count).to be(4)
      end
    end
  end

  describe "#orbit_count_checksum" do
    let(:map_data) {
      %w[
        COM)B
        B)C
        C)D
        D)E
        E)F
        B)G
        G)H
        D)I
        E)J
        J)K
        K)L
      ]
    }

    it "should be 42" do
      expect(subject.orbit_count_checksum).to be(42)
    end
  end
end
