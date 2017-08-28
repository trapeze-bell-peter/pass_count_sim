# frozen_string_literal: true
#
require 'forwardable'

# This class simulates the passenger counter.
class PassCounter
  extend Forwardable

  attr_reader :accumulated_count

  # @param [BusSimulation] bus_simulation
  # @param [Float] positive_error_rate is the percentage error rate on seeing a passenger who is not there
  # @param [Float] negative_error_rate is the percentage error rate on not seeing a passenge who is there.
  def initialize(bus_simulation, positive_error_rate, negative_error_rate)
    @bus_simulation = bus_simulation
    @counter_error_simulator = CounterErrors.new(positive_error_rate, negative_error_rate)
    @counter_events = Array.new(nr_stops) { Hash.new(0) }
    @accumulated_count = 0
  end

  def_delegators :@bus_simulation, :current_stop, :next_stop, :nr_stops, :stops_in_sequence

  # returns the number of people that the counter has seen boarding.
  def counter_boarded
    @counter_events[current_stop][:boarding]
  end

  # simulates the process of counting people boarding the bus and being counted by the counter
  def boarding(true_nr_boarded)
    @counter_events[current_stop][:boarding] = @counter_error_simulator.counter_result(true_nr_boarded)
    @accumulated_count += @counter_events[current_stop][:boarding]
    @counter_events[current_stop][:boarding]
  end

  # returns the number of people that the counter has seen alighting
  # @return [Fixnum] the number of people who alighted according to the counter
  def counter_alighted
    @counter_events[current_stop][:alighting]
    @accumulated_count -= @counter_events[current_stop][:alighting]
    @counter_events[current_stop][:alighting]
  end

  # simulates the process of counting people alighting the bus and being counted by the counter
  # @param [Fixnum] true_nr_alighted true number of people who alighted
  # @return [Fixnum] the number of people the counter saw alighting
  def alighting(true_nr_alighted)
    @counter_events[current_stop][:alighting] = @counter_error_simulator.counter_result(true_nr_alighted)
  end

  # Iterate over the array of stops with the alighting and boarding events.  For the first one, we are not interested
  # in alighting.
  def history_on_bus
    stops_in_sequence.inject(0) do |accum, stop|
      accum + @counter_events[stop][:boarding] - @counter_events[stop][:alighting]
    end
  end
end

