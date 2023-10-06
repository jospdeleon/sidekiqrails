# inside app/jobs/broken_world_job.rb
class BrokenWorldJob < ApplicationJob
  sidekiq_options queue: :critical,
                  retry: 5

  def perform(*args)
    # Simulates a long, time-consuming task
    sleep rand(5...10)
    # Will display current time, milliseconds included
    p "hello from BrokenWorldJob #{Time.now().strftime('%F - %H:%M:%S.%L')}"
    raise 'Ooooooops ...'
  end

end
