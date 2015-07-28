module Sidekiq
  module Promise
    class RedisConnection < ::Sidekiq::RedisConnection
      def self.log_info *_; end
    end
  end
end
