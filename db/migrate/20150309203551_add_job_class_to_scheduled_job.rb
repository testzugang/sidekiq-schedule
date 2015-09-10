class AddJobClassToScheduledJob < ActiveRecord::Migration
  def change
    add_column :sidekiq_schedule_scheduled_jobs, :worker_class, :string
  end
end
