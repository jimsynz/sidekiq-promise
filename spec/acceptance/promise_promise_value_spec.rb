require 'spec_helper'

describe 'Promise promise value' do
  before(:all) { start_worker }
  after(:all)  { kill_worker }
  after        { clear_jobs }

  let(:value)   { rand(99) }
  let(:result)  { value * value }
  let(:promise) { PromisingValuableWorker.as_promise(value) }
  subject { promise }

  its(:final)  { should be_resolved }
  its(:final)  { should_not be_rejected }
  its(:result) { should eq result }
end
