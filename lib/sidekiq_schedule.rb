require "sidekiq"
require "sidekiq_schedule/engine"

module SidekiqSchedule

  mattr_accessor :worker_classes

end
