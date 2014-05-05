require 'spec_helper'

describe 'Failing job as promise' do
  before(:all) { start_worker }
  after(:all)  { kill_worker }
  before       { clear_jobs }
  after        { clear_jobs }

  let(:promise) { RaiseyWorker.as_promise }
  subject { promise }

  its(:final) { should_not be_resolved }
  its(:final) { should be_rejected }

  describe '#then' do
    it 'does not yield' do
      expect { |b| promise.final.then(&b) }.not_to yield_control
    end
  end

  describe '#fail' do
    it 'yields' do
      expect { |b| promise.final.fail(&b) }.to yield_control
    end
  end
end
