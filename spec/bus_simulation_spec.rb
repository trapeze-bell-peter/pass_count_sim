# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BusSimulation do
  subject { described_class.new(5, 10, 0.05, 0.05) }

  it 'has a version number' do
    expect(PassCountSim::VERSION).not_to be nil
  end

  describe '#next_stop' do
    it 'will correctly loop around the stops' do
      expect(subject.next_stop).to eq(1)
      3.times { subject.next_stop }
      expect(subject.next_stop).to eq(0)
    end
  end

  describe '#boarding' do
    it 'will board the passengers and determine random stops for them to alight' do
      # Counter will give perfect readings
      allow(Random).to receive(:rand).with(no_args) { 0.5 } # perfect reading

      # this sets up the random number generator to return an initial 4 representing
      # number of people boarding - one for each of the subsequent stops.
      allow(Random).to receive(:rand).with(20) { 4 }

      # This is followed by a stops at which to alight.  We return a sequence starting at 1
      # and increasing. This should mean that one person gets off at each stop.
      allow(Random).to receive(:rand).with(4) { @last_value = @last_value ? @last_value + 1 : 0 }

      # we are going to start the process at stop 3 rather than the default stop 0 so we can test the
      # correct looping behaviour of the methods.
      subject.instance_variable_set(:@current_stop, 3)

      expect(subject.boarding).to eq 4
      expect(subject.boarded).to eq 4
      4.times do |i|
        subject.next_stop
        expect(subject.alighting).to eq 1
        expect(subject.alighted).to eq 1
      end
      subject.next_stop
      expect(subject.alighting).to eq 0
      expect(subject.alighted).to eq 0
    end
  end

  describe '#stops_in_sequence' do
    it 'will return the stops starting at zero' do
      expect(subject.stops_in_sequence.each.to_a).to eq (0..4).to_a
    end

    it 'will return the stops starting at 3' do
      subject.instance_variable_set(:@current_stop, 3)
      expect(subject.stops_in_sequence.each.to_a).to eq [3, 4, 0, 1, 2]
    end
  end
end
