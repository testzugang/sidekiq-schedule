class AddParamsToScheduledJob < ActiveRecord::Migration
  def change
    add_column :sidekiq_schedule_scheduled_jobs, :params, :text
  end
end
