module Sidekiq
  module Promise
    class ServerMiddleware < Middleware

      def call worker, job, queue
        job_dequeued job
        yield
        job_completed job
      rescue Exception => e
        job_errored job, e
        raise e
      end

    end
  end
end
