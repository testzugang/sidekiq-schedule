require "sidekiq_schedule/web_extension"

module Web

  if defined?(Sidekiq::Web)
    Sidekiq::Web.register SidekiqSchedule::WebExtension

    Sidekiq::Web.tabs["Scheduled Jobs"] = "scheduled_jobs"
  end

end
