module Sidekiq
  module Promise
    class Subscription
      class << self
        def subscribe &block
          subscriptions << block
          block
        end

        def unsubscribe id
          subscriptions.delete id
        end

        def ready
          @ready ||= MrDarcy.promise do |promise|
            Sidekiq::Promise.redis_pool.with do |redis|
              redis.subscribe Sidekiq::Promise::Middleware::CHANNEL do |on|
                on.subscribe do
                  promise.resolve true
                end
                on.message do |channel,message|
                  message = JSON.parse(message)
                  subscriptions.each do |block|
                    block.call message
                  end
                end
              end
            end
          end
        end

        private

        def subscriptions
          @subscriptions ||= []
        end
      end
    end
  end
end
