class PromisingValuableWorker
  include Sidekiq::Promise

  def perform i
    MrDarcy.promise do
      resolve i * i
    end
  end
end
