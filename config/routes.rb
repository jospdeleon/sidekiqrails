Rails.application.routes.draw do
  get "welcome/index"

  # route where any visitor requires the job to be triggered
  post "welcome/trigger_job"

  # where visitor is redirected once job has been called
  get "other/job_done"

  root to: "welcome#index"

  require 'sidekiq/prometheus/exporter'
  mount Sidekiq::Prometheus::Exporter => '/metrics'
end
