require 'sidekiq/api'

module SidekiqHelpers
  def start_worker
    return if @worker_pid
    server_path = File.expand_path('../../spec_server.rb', __FILE__)
    @worker_pid = Process.spawn("bundle exec sidekiq -t 0 -r #{server_path}")
  end

  def kill_worker
    return unless @worker_pid
    Process.kill('TERM', @worker_pid)
    Process.wait(@worker_pid)
  rescue Errno::ESRCH
  ensure
    @worker_pid = nil
  end

  def clear_jobs
    Sidekiq::Queue.new.clear
    Sidekiq::RetrySet.new.clear
    Sidekiq::ScheduledSet.new.clear
  end

end
