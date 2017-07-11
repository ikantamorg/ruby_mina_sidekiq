class PrepareScheduledPostsToSendJob < ActiveJob::Base
  queue_as :post_prepare

  def perform(timestamp)
    date_time = Time.at(timestamp).utc.to_datetime
    Posts::ReadyToSendQuery.new.fetch_by_time(date_time).each do |post|
      post.preparing!
      SendPostToChannelJob.perform_later(post)
    end
  end
end
