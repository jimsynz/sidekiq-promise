require "sidekiq/promise/version"
require 'sidekiq'
require 'json'
require 'mr_darcy'
require 'sidekiq/promise/middleware'
require 'sidekiq/promise/client_middleware'
require 'sidekiq/promise/server_middleware'
require 'sidekiq/promise/worker'


module Sidekiq
  module Promise
    def self.included(base)
      base.send :include, Sidekiq::Worker unless base.ancestors.member? Sidekiq::Worker
      base.extend(ClassMethods)
      base.send :sidekiq_options, retry: false
      unless MrDarcy.driver == :celluloid
        STDOUT.puts "Switched your MrDarcy driver to Celluloid - it was #{MrDarcy.driver}"
        MrDarcy.driver = :celluloid
      end
    end

    module ClassMethods
      def as_promise(*args)
        ::Sidekiq::Promise::Worker.new self, *args
      end
    end

    module_function
    def enable_middleware!
      raise RuntimeError, "WARNING: Unable to configure required middleware. sidekiq-promise won't work :(" unless Sidekiq.respond_to? :configure_server
      Sidekiq.configure_server do |config|
        config.server_middleware do |chain|
          chain.add Sidekiq::Promise::ServerMiddleware
        end
      end
      Sidekiq.configure_client do |config|
        config.client_middleware do |chain|
          chain.add Sidekiq::Promise::ClientMiddleware
        end
      end
    end
  end
end

Sidekiq::Promise.enable_middleware!
