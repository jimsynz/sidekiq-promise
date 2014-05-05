require 'sidekiq/promise'
Dir[File.expand_path('../workers/**/*.rb', __FILE__)].each { |f| require f }
