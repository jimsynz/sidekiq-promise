module Sidekiq
  module Promise
    class ServerMiddleware < Middleware

      def call worker, job, queue
        job_dequeued job
        result = yield
        result.raise if thenable? result
        job_completed job
      rescue Exception => e
        job_errored job, e
        raise e
      end

      private

      def thenable? obj
        obj.respond_to?(:then) && obj.respond_to?(:fail)
      end

    end
  end
end
