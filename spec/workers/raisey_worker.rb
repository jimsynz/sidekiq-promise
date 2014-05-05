class RaiseyWorker
  include Sidekiq::Worker
  include Sidekiq::Promise

  sidekiq_options retry: false, backtrace: false

  def perform msg="it's time I got a raise"
    raise RuntimeError, msg
  end
end
