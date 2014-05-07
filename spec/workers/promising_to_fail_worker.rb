class PromisingToFailWorker
  include Sidekiq::Promise

  def perform
    MrDarcy.promise do
      sleep 0.5
      reject "for the LOLs"
    end
  end
end
