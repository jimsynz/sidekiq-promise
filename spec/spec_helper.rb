require 'rspec/its'
require 'mr_darcy'
MrDarcy.driver = :celluloid
require 'sidekiq/promise'
require 'pry'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }
Dir[File.expand_path('../workers/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.formatter = :documentation
  config.extend ContextHelpers
  config.include SidekiqHelpers, file_path: %r(spec/acceptance)
end
