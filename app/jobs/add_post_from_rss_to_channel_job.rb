class AddPostFromRssToChannelJob < ActiveJob::Base
  queue_as :rss_feeds

  def perform(channel)
    ::ServicesContainer[:rss_reader].add_posts(channel)
  rescue Pundit::NotAuthorizedError
  end
end
