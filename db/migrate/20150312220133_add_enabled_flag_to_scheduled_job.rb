class AddEnabledFlagToScheduledJob < ActiveRecord::Migration
  def change
    add_column :sidekiq_schedule_scheduled_jobs, :enabled, :boolean
  end
end
