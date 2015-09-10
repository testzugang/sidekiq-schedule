require 'cron_parser'

module SidekiqSchedule
  module WebExtension

    def self.registered(app)
      view_path = File.join(File.expand_path('..', __FILE__), 'views')

      app.settings.locales << File.join(File.expand_path("..", __FILE__), 'locales')

      #index page of scheduled_jobs
      app.get '/scheduled_jobs' do
        @jobs = SidekiqSchedule::ScheduledJob.order("lower(name)").all
        render(:erb, File.read(File.join(view_path, 'index.erb')))
      end

      #new scheduled job
      app.get '/scheduled_job/new' do
        @job = SidekiqSchedule::ScheduledJob.new
        @workers = SidekiqSchedule.worker_classes
        render(:erb, File.read(File.join(view_path, 'form.erb')))
      end

      #save scheduled_job
      app.post '/scheduled_job/create' do
        @job = SidekiqSchedule::ScheduledJob.new(params[:scheduled_job])
        if @job.save
          redirect "#{ root_path }scheduled_jobs"
        else
          render(:erb, File.read(File.join(view_path, 'form.erb')))
        end
      end

      #edit scheduled_job
      app.post '/scheduled_job/:id/edit' do |id|
        @job = SidekiqSchedule::ScheduledJob.find(id)
        @workers = SidekiqSchedule.worker_classes
        render(:erb, File.read(File.join(view_path, 'form.erb')))
      end

      #update scheduled_job
      app.patch '/scheduled_job/:id/update' do |id|
        @job = SidekiqSchedule::ScheduledJob.find(id)
        if @job.update_attributes(params[:scheduled_job])
          render(:erb, File.read(File.join(view_path, 'index.erb')))
        else
          @workers = SidekiqSchedule.worker_classes
          render(:erb, File.read(File.join(view_path, 'form.erb')))
        end
      end

      #delete scheduled_job
      app.post '/scheduled_job/:id/delete' do |id|
        if job = SidekiqSchedule::ScheduledJob.find(id)
          job.destroy
        end
        redirect "#{ root_path }scheduled_jobs"
      end

      #enable scheduled_job
      app.post '/scheduled_job/:id/enable' do |id|
        if job = SidekiqSchedule::ScheduledJob.find(id)
          job.enabled = true
          job.save
        end
        redirect "#{ root_path }scheduled_jobs"
      end

      #disable scheduled_job
      app.post '/scheduled_job/:id/disable' do |id|
        if job = SidekiqSchedule::ScheduledJob.find(id)
          job.enabled = false
          job.save
        end
        redirect "#{ root_path }scheduled_jobs"
      end

      #enqueue scheduled_job
      app.post '/scheduled_job/:id/enqueue' do |id|
        if job = SidekiqSchedule::ScheduledJob.find(id)
          job.enqueue!
        end
        redirect "#{ root_path }scheduled_jobs"
      end
    end
  end
end