require 'sidekiq/promise'
require 'mr_darcy'
require 'pry'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }
Dir[File.expand_path('../workers/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.formatter = :documentation
  config.extend ContextHelpers
  config.include SidekiqHelpers, example_group: {
    file_path: %r(spec/acceptance)
  }
end
