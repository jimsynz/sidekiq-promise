class PromisingWorker
  include Sidekiq::Promise

  def perform
    MrDarcy.all_promises do
      10.times.map do
        SleepyWorker.as_promise 1
      end
    end
  end
end
