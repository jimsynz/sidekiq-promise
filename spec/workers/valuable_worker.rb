class ValuableWorker
  include Sidekiq::Promise

  def perform i
    i * i
  end
end
