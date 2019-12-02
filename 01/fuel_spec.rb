require 'rspec'
require_relative 'fuel'

RSpec.describe '#fuel_required' do
  subject { fuel_required(mass) }

  context "with module mass of 12" do
    let(:mass) { 12 }
    it { is_expected.to eq(2) }
  end

  context "with module mass of 14" do
    let(:mass) { 14 }
    it { is_expected.to eq(2) }
  end

  context "with module mass of 1,969" do
    let(:mass) { 1_969 }
    it { is_expected.to eq(654) }
  end

  context "with module mass of 100,756" do
    let(:mass) { 100_756 }
    it { is_expected.to eq(33_583) }
  end
end

RSpec.describe '#net_fuel_required' do
  subject { net_fuel_required(mass) }

  context "with module mass of 12" do
    let(:mass) { 12 }
    it { is_expected.to eq(2) }
  end

  context "with module mass of 14" do
    let(:mass) { 14 }
    it { is_expected.to eq(2) }
  end

  context "with module mass of 1,969" do
    let(:mass) { 1_969 }
    it { is_expected.to eq(966) }
  end

  context "with module mass of 100,756" do
    let(:mass) { 100_756 }
    it { is_expected.to eq(50_346) }
  end
end
