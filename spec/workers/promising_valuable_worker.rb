class PromisingValuableWorker
  include Sidekiq::Promise

  def perform i
    MrDarcy.promise do |p|
      p.resolve i * i
    end
  end
end
