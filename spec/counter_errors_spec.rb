require 'spec_helper'

describe CounterErrors do
  subject { CounterErrors.new(0.05, 0.05) }
  let(:nr_reads) { 10 }
  it 'will return correct number of events if normal event' do
    allow(Random).to receive(:rand).with(no_args) { 0.5 }
    expect( subject.counter_result(nr_reads) ).to eq(nr_reads)
  end

  it 'will return twice as many events if all reads over read' do
    allow(Random).to receive(:rand).with(no_args) { 0.9 }
    expect( subject.counter_result(nr_reads) ).to eq(nr_reads*2)
  end

  it 'will return no events if all reads miss' do
    allow(Random).to receive(:rand).with(no_args) { 0.95 }
    expect( subject.counter_result(nr_reads) ).to eq(0)
  end
end