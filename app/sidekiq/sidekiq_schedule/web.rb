require "sidekiq_schedule/web_extension"

module Web

  require 'sidekiq/web' unless defined?(Sidekiq::Web)
  Sidekiq::Web.register SidekiqSchedule::WebExtension
  Sidekiq::Web.tabs["Scheduled Jobs"] = "scheduled_jobs"
  Sidekiq::Web.set :locales, Sidekiq::Web.locales << File.expand_path(File.dirname(__FILE__) + "/../../../config/locales")
end
