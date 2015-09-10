require 'sidekiq/web'
require 'sidekiq_schedule/web'

Rails.application.routes.draw do

  get "dummy/index"

  mount SidekiqSchedule::Engine => "/engine"
  mount Sidekiq::Web => '/engine/sidekiq'

end
