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
        next_run = cron_parser.next(DateTime.now)
        countdown = (next_run - DateTime.now).to_i
        worker_class.perform_in(countdown.seconds, job.params)
      else
        puts 'Job could not be scheduled: Was nil'
      end
    end

    def self.run job
      if job
        worker_class = job.worker_class.constantize
        worker_class.perform_async(job.params)
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

    attr_protected :cron, :last_error, :name, :worker_class, :worker_id, :enabled, :last_scheduled, :params

    def enabled?
      enabled
    end

    def enqueue!
      worker_class = self.worker_class.constantize
      worker_class.perform_async(self.params)
      self.last_scheduled = DateTime.now
      self.save
    end

  end
end
