class PrependPostsFromRssFeedJob < ActiveJob::Base
  queue_as :default

  def perform
    # to avoid duplication of posts in the channel creates a task for the channel
    ::Channels::ChannelQuery.new.fetch_exists_rss_feeds.each do |channel|
      AddPostFromRssToChannelJob.perform_later(channel)
    end
  end
end
