# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PassCounter do
  context 'mocked bus_simulation' do
    subject { described_class.new(bus_simulation, 0.05, 0.05) }

    let(:bus_simulation) { double('bus_simuluation', nr_stops: 5, current_stop: 3) }

    # returns the number of people that the counter has seen boarding.
    describe '#counter_boarded' do
      it 'will return the number of people the counter saw boarding' do
        allow(Random).to receive(:rand).with(no_args) { 0.5 } # perfect reading
        expect(subject.boarding(5)).to eq 5
      end
    end

    describe '#boarding' do
      it 'will simulate the number of people the counter saw boarding' do
        allow(Random).to receive(:rand).with(no_args) { 0.5 } # perfect reading
        subject.boarding(5)
        expect(subject.counter_boarded).to eq 5
      end
    end

    describe '#counter_alighted' do
      it 'will return the number of people the counter saw alighting' do
        allow(Random).to receive(:rand).with(no_args) { 0.5 } # perfect reading
        expect(subject.alighting(5)).to eq 5
      end
    end

    describe '#alighting' do
      it 'will simulate the number of people the counter saw boarding' do
        allow(Random).to receive(:rand).with(no_args) { 0.5 } # perfect reading
        subject.alighting(5)
        expect(subject.counter_alighted).to eq 5
      end
    end
  end

  # Iterate over the array of stops with the alighting and boarding events.  For the first one, we are not interested
  # in alighting.
  describe '#history_on_bus' do
    let(:bus_simulation) { BusSimulation.new(5, 10, 0.05, 0.05) }

    it 'will total the number of people on the bus assuming everyone has got on or off on the current cycle' do
      allow(Random).to receive(:rand).with(no_args) { 0.5 } # perfect reading
      allow(Random).to receive(:rand).with(20) { 4 } # four always get on and off.
      allow(Random).to receive(:rand).with(4) { 2 } # Always get off two steps from here.

      bus_simulation.run(5)

      puts "current stop: #{bus_simulation.current_stop}"
      expect(bus_simulation.history_on_bus).to eq(bus_simulation.on_vehicle)
    end
  end
end
