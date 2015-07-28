require 'spec_helper'

describe Sidekiq::Promise::ServerMiddleware do
  let(:worker)     { double :worker }
  let(:job)        { { jid: '12345' } }
  let(:queue)      { 'default' }
  let(:middleware) { described_class.new }

  describe '#call' do
    When 'the job is successful' do
      it 'dequeues the job, then yields, then completes' do
        expect(middleware).to receive(:job_dequeued).with(job)
        expect(middleware).to receive(:job_completed).with(job, nil)
        expect { |b| middleware.call(worker, job, queue, &b) }.to yield_control
      end
    end

    When 'the jobs fails' do
      it 'dequeues the job, then yeilds, then errors' do
        exception = RuntimeError.new('test exception')
        expect(middleware).to receive(:job_dequeued).with(job)
        expect(middleware).to receive(:job_errored).with(job, exception)
        expect do
          middleware.call(worker,job,queue) { raise exception }
        end.to raise_error(RuntimeError)
      end
    end
  end
end
