Rails.application.routes.draw do

  get "dummy/index"

  mount SidekiqSchedule::Engine => "/engine"

end
