# frozen_string_literal: true

class BusSimulation
  extend Forwardable

  def_delegators :@pass_counter_sim, :counter_boarded, :counter_boarded, :counter_alighted, :history_on_bus,
                 :accumulated_count

  attr_reader :current_stop
  attr_reader :nr_stops
  attr_reader :average_borders
  attr_reader :on_vehicle
  attr_reader :boarded, :alighted

  # @param [Fixnum] nr_stops is the number of stops on the route
  # @param [Fixnum] average_boarders is the number of people boarding the bus at each stop
  # @param [Float] positive_error_rate is the percentage error rate on seeing a passenger who is not there
  # @param [Float] negative_error_rate is the percentage error rate on not seeing a passenge who is there.
  def initialize(nr_stops, average_boarders, positive_error_rate, negative_error_rate)
    @nr_stops = nr_stops
    @average_borders = average_boarders
    @pass_counter_sim = PassCounter.new(self, positive_error_rate, negative_error_rate)

    @on_vehicle = 0

    @passengers_alighting = Array.new(nr_stops, 0)
    @current_stop = 0
  end

  def run(steps = 10000)
    steps.times do
      @on_vehicle += -alighting + boarding
      puts "stop #{current_stop}, alighting: #{alighted}, boarding: #{boarded}, on bus after departure: #{on_vehicle}, counter alighted: #{counter_alighted}, counter bordered: #{counter_boarded}, accum counter #{accumulated_count}, history: #{history_on_bus}"
      next_stop
    end
  end

  # Iterate through the number of stops
  def next_stop
    @current_stop += 1
    @current_stop = 0 if @current_stop == nr_stops
    @current_stop
  end

  def boarding
    @boarded = Random.rand(average_borders*2)
    @boarded.times { @passengers_alighting[(current_stop + Random.rand(nr_stops-1) + 1)% nr_stops] += 1 }
    @pass_counter_sim.boarding(@boarded)
    @boarded
  end

  def alighting
    @alighted = @passengers_alighting[current_stop]
    @pass_counter_sim.alighting(@alighted)
    @alighted
  end

  def stops_in_sequence
    Enumerator.new(nr_stops) do |y|
      stop = current_stop
      nr_stops.times do
        y << stop
        stop = (stop + 1) % nr_stops
      end
    end
  end
end
