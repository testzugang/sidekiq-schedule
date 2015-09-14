class AddLastScheduledToScheduledJob < ActiveRecord::Migration
  def change
    add_column :sidekiq_schedule_scheduled_jobs, :last_scheduled, :datetime
  end
end
