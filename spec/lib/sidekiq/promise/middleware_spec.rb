require 'spec_helper'

describe Sidekiq::Promise::Middleware do
  let(:redis_client) { double :redis_client }
  let(:redis_pool)   { MockClientPool.new redis_client }
  let(:middleware)   { described_class.new }

  describe '#job_enqueued' do
    it 'delegates to #publish_message' do
      expect(middleware).to receive(:publish_message).with(redis_pool, {status: 'enqueued', job: {}, jid: nil})
      middleware.job_enqueued Hash.new, redis_pool
    end
  end

  describe '#job_dequeued' do
    it 'delegates to #publish_message' do
      expect(middleware).to receive(:publish_message).with(redis_pool, {status: 'dequeued', job: {}, jid: nil})
      middleware.job_dequeued Hash.new, redis_pool
    end
  end

  describe '#job_completed' do
    it 'delegates to #publish_message' do
      expect(middleware).to receive(:publish_message).with(redis_pool, {status: 'complete', job: {}, jid: nil, result: :result})
      middleware.job_completed Hash.new, :result, redis_pool
    end
  end

  describe '#job_errored' do
    it 'delegates to #publish_message' do
      expect(middleware).to receive(:publish_message).with(redis_pool, {status: 'error', job: {}, jid: nil, exception: {class: 'RuntimeError', message: 'fake error', backtrace: nil}})
      middleware.job_errored Hash.new, RuntimeError.new('fake error'), redis_pool
    end
  end

  describe '#publish_message' do
    it 'sends the message to redis' do
      message = {message: 'fake message'}
      expect(redis_client).to receive(:publish).with('/sidekiq_jobs', message.to_json)
      middleware.publish_message redis_pool, message
    end
  end
end
