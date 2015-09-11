require 'sidekiq/api'
module SidekiqSchedule

  class ScheduledJob < ActiveRecord::Base

    def self.clear_queue
      Sidekiq::ScheduledSet.new.clear

      # Remove a queue and all of its jobs
      Sidekiq.redis do |r|
        r.srem "queues", "sjw"
        r.del "queue:sjw"
      end

    end

    def self.setup_queue
      # schedule every job
      ScheduledJob.all.each do |job|
        self.schedule job
      end
    end

    def self.schedule job
      if job
        worker_class = job.worker_class.constantize
        cron_parser = CronParser.new(job.cron)
        next_run = cron_parser.next(Time.now)
        countdown = (next_run - DateTime.now).to_i
        worker_class.perform_in(countdown.seconds, job.id)
      else
        puts 'Job could not be scheduled: Was nil'
      end
    end

    def self.run job
      if job
        worker_class = job.worker_class.constantize
        worker_class.perform_async(job.id)
      else
        puts 'Job could not be scheduled: Was nil'
      end
    end

    def self.schedule_id(scheduled_id)
      job = ScheduledJob.find(scheduled_id)
      self.schedule job
    end

    def self.cancel job
      r = Sidekiq::ScheduledSet.new
      jobs = r.select { |j| j.klass == job.worker_class }
      jobs.each(&:delete)
    end

    attr_accessible :cron, :last_error, :name, :worker_class, :worker_id, :enabled, :last_scheduled

    def enabled?
      enabled
    end

    def enqueue!
      # push job to sidekiq now
    end

  end
end
