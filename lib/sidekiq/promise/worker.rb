module Sidekiq
  module Promise
    class Worker < ::MrDarcy::Promise::Celluloid

      attr_accessor :jid

      def initialize worker_klass, *args
        @worker_klass = worker_klass
        @args         = args

        this = self
        block = proc do
          this.send :subscribe
        end
        super block
      end

      private

      def evaluate_promise &block
        begin
          block.call ::MrDarcy::Promise::DSL.new(self)
        rescue Exception => e
          reject e
        end
      end

      def subscribe
        @redis = Sidekiq.redis_pool.checkout
        @redis.subscribe ::Sidekiq::Promise::Middleware::CHANNEL do |on|
          on.subscribe { queue_job }
          on.message do |channel,message|
            message = JSON.parse(message)
            process_message message if applicable? message
          end
        end
      end

      def unsubscribe
        @redis.unsubscribe
        Sidekiq.redis_pool.checkin
      end

      def queue_job
        future = ::Celluloid::Future.new do
          @worker_klass.perform_async *@args
        end
        @jid = future.value
      end

      def applicable? message
        message['jid'] == jid
      end

      def process_message message
        send "process_#{message['status']}_message", message
      end

      def process_complete_message message
        unsubscribe
        resolve message['job']
      end

      def process_error_message message
        unsubscribe
        reject message['exception']
      end

      def noop *args; end
      alias process_dequeued_message noop
      alias process_enqueued_message noop
    end
  end
end
