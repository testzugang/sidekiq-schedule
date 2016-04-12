require 'cron_parser'
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
        now = DateTime.now
        offset = Time.zone_offset(Time.now.zone)

        logger.info "poll #{now}"

        begin

          ScheduledJob.all.each do |job|
            if job.enabled
              last_scheduled = (job.last_scheduled || job.created_at) + offset.seconds
              cron_parser = CronParser.new(job.cron)
              next_run = DateTime.parse(cron_parser.next(last_scheduled).to_s, DateTime)
              if next_run.to_i < now.to_i
                logger.info "Job: #{job.name}  #{job.worker_class}  #{job.cron}  last scheduled #{last_scheduled}, next run #{next_run.to_s}"
                job.enqueue!
              end
            end
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