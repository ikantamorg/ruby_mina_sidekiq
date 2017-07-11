class ReschedulePostsJob < ActiveJob::Base
  queue_as :default

  def perform(channel, planner)
    ServicesContainer[:posts_rescheduler].reschedule(channel, planner)
  end
end
