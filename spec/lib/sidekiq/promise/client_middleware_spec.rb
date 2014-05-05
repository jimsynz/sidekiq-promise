require 'spec_helper'

describe Sidekiq::Promise::ClientMiddleware do
  let(:worker_class) { Class.new }
  let(:job)          { double :job }
  let(:queue)        { 'default' }
  let(:redis_pool)   { double :redis_pool }
  let(:middleware)   { described_class.new }

  describe '#call' do
    it 'sends a message about enqueuing the job, then yields' do
      expect(middleware).to receive(:job_enqueued).with(job, redis_pool)
      expect { |b| middleware.call(worker_class, job, queue, redis_pool, &b) }.to yield_control
    end
  end
end
