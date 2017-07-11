class UpdateAvatarForLinkedinChannelsJob < ActiveJob::Base
  queue_as :default
  def perform(channels)
    ServicesContainer[:profile_picture_updater].update_profiles_picture(channels)
  end
end
