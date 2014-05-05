class CrashyWorker
  include Sidekiq::Worker
  include Sidekiq::Promise

  def perform
    Process.kill('TERM', Process.pid)
    sleep 12
  end
end
