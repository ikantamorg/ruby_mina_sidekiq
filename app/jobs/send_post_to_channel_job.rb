class SendPostToChannelJob < ActiveJob::Base
  queue_as :post_send

  def perform(post)
    case post.channel.provider
    when 'twitter'
      ::ServicesContainer[:social_provider_twitter].send_post!(post)
    when 'linkedin'
      ::ServicesContainer[:social_provider_linkedin].send_post!(post)
    when 'facebook'
      ::ServicesContainer[:social_provider_facebook].send_post!(post)
    end
    post.update(status: Post.statuses[:posted], send_time: DateTime.now.utc)
  rescue ::Twitter::Error::Unauthorized, ::LinkedIn::Errors::UnauthorizedError => e
    post.channel.disconnected!
    post_update_failed(post, e)
  rescue ::Koala::Facebook::AuthenticationError, ::Koala::Facebook::OAuthTokenRequestError => e
    post.channel.disconnected!
    post_update_failed(post, e)
  rescue ::Twitter::Error, ::LinkedIn::Errors::LinkedInError, ::Koala::KoalaError => e
    post_update_failed(post, e)
  end

  private

  def post_update_failed(post, e)
    post.update(status: ::Post.statuses[:failed], error: e.message)
  end
end
