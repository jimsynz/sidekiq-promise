module Sidekiq
  module Promise
    class ServerMiddleware < Middleware

      def call worker, job, queue
        job_dequeued job
        result = yield
        if thenable? result
          result.raise
          job_completed job, result.result
        else
          job_completed job, result
        end
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
