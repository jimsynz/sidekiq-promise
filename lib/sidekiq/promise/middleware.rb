module Sidekiq
  module Promise
    class Middleware

      CHANNEL = '/sidekiq_jobs'

      def job_enqueued job, redis_pool=Sidekiq.redis_pool
        publish_message redis_pool, status: 'enqueued', job: job, jid: job['jid']
      end

      def job_dequeued job, redis_pool=Sidekiq.redis_pool
        publish_message redis_pool, status: 'dequeued', job: job, jid: job['jid']
      end

      def job_completed job, result=nil, redis_pool=Sidekiq.redis_pool
        publish_message redis_pool, status: 'complete', job: job, jid: job['jid'], result: result
      end

      def job_errored job, e, redis_pool=Sidekiq.redis_pool
        publish_message redis_pool, status: 'error', job: job, exception: {class: e.class.to_s, message: e.message, backtrace: e.backtrace}, jid: job['jid']
      end

      def publish_message redis_pool, message
        redis_pool.with do |redis|
          redis.publish CHANNEL, message.to_json
        end
      end
    end
  end
end
