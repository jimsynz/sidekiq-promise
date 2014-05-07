require 'spec_helper'

describe 'Promising job as promise' do
  before(:all) { start_worker }
  after(:all)  { kill_worker }
  before       { clear_jobs }
  after        { clear_jobs }

  let(:promise) { PromisingWorker.as_promise }
  subject { promise }

  its(:final) { should be_resolved }
  its(:final) { should_not be_rejected }

  describe '#then' do
    it 'yields' do
      expect { |b| promise.final.then(&b) }.to yield_control
    end
  end

  describe '#fail' do
    it 'does not yield' do
      expect { |b| promise.final.fail(&b) }.not_to yield_control
    end
  end
end
