require "sidekiq"
require "sidekiq_schedule/engine"

require_relative "../app/sidekiq/sidekiq_schedule/poller"
require_relative "../app/sidekiq/sidekiq_schedule/launcher"

module SidekiqSchedule

  mattr_accessor :worker_classes

end
