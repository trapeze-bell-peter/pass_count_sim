class CounterErrors
  # @param [Float] positive_error_rate
  # @param [Float] negative_error_rate
  def initialize(positive_error_rate, negative_error_rate)
    @works_correctly = 1.0 - positive_error_rate - negative_error_rate
    @positive_threshold = @works_correctly + positive_error_rate
  end

  # We are expecting to see n events. This simulates the impact of random errors on each input.
  # @param [Fixnum] input the number of events that occur
  # @return [Fixnum] the number of events that the sensor detects
  def counter_result(input)
    result = 0
    input.times { result += single_event_output }
    result
  end

  # The code makes a working assumption that each time the counter should trigger it can do one of three things:
  # - it triggers correctly
  # - it fails to trigger inspite of someone going thru it
  # - it incorrectly registers two events when one would have been better
  def single_event_output
    prob = Random.rand
    if prob < @works_correctly
      1
    elsif prob < @positive_threshold
      2
    else
      0
    end
  end
end