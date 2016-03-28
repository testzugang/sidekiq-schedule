class DummyWorker

  include Sidekiq::Worker
  sidekiq_options :queue => :dummy

  def perform (values)
    logger.info 'DummyWorker performing ...'
    logger.info "params: #{values}"
  end

end