class DummyWorker

  include Sidekiq::Worker
  sidekiq_options :queue => :dummy

  def perform
    logger.info 'DummyWorker performing ...'
  end

end