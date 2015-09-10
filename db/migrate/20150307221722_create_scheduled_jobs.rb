class CreateScheduledJobs < ActiveRecord::Migration
  def change
    create_table :sidekiq_schedule_scheduled_jobs do |t|
      t.string :name
      t.string :cron
      t.integer :worker_id
      t.string :last_error

      t.timestamps
    end
  end
end
