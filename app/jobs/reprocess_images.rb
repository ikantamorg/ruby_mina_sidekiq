class ReprocessImages < ActiveJob::Base
  queue_as :default

  def perform
    FileImage.all.each { |file| recreate!(file.identifier) }
  end

  private

  def recreate!(image)
    image.recreate_versions!
  rescue => e
    logger.error e.message
  end
end
