class CreateZendeskTicketJob < ActiveJob::Base
  queue_as :default
  def perform(get_in_touch_message)
    ::ServicesContainer[:tickets_provider_zendesk].get_in_touch_send!(get_in_touch_message)
  end
end
