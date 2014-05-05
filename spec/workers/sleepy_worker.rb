class SleepyWorker
  include Sidekiq::Worker
  include Sidekiq::Promise

  def perform delay
    sleep delay
  end
end
