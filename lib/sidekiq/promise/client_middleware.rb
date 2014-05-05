module Sidekiq
  module Promise
    class ClientMiddleware < Middleware

      def call worker_class, job, queue, redis_pool
        job_enqueued job, redis_pool
        yield
      end

    end
  end
end
