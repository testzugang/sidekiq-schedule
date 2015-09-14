require 'sidekiq/util'
require 'sidekiq/actor'

module SidekiqSchedule

  class Poller
    include Sidekiq::Util
    include Sidekiq::Actor

    def start
      watchdog('scheduled poller thread died!') do
        every(poll_interval) { poll }
      end
    end

    def poll
      watchdog('scheduled poller thread died!') do
        logger.info 'wait'

        now = Time.now
        logger.info "poll #{now}"

        begin

          ScheduledJob.all.each do |job|
            logger.info "job: #{job.name}  #{job.worker_class}  #{job.cron}"
          end

        rescue Exception => ex
          # Most likely a problem with redis networking.
          # Punt and try again at the next interval
          logger.error ex.message
          logger.error ex.backtrace.first
        end
      end
    end

    private

    def poll_interval
      Sidekiq.options[:poll_interval] || 10
    end

  end

end