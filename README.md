# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

1. docker-compose build
2. docker-compose up -d - creates all containers
3. docker-compose logs
4. docker-compose exec app bundle exec rails db:create db:migrate - only need to do this once
5. https://localhost:3000
6. 

10. docker-compose down

had to install colima bec we can't use docker desktop
  brew install colima
  colima start
had to use postgres user

kubectl create configmap app-wrapper --from-file=entrypoints/docker-entrypoint.sh
kubectl create configmap wrapper --from-file=entrypoints/sidekiq-entrypoint.sh

had to do this after applying db-create:
  k delete job db-create

kubectl apply -f cluster-role.yaml
kubectl apply -f ksm-cluster-role-binding.yaml
kubectl apply -f ksm-cluster-role.yaml
kubectl apply -f ksm-deployment.yaml
kubectl apply -f ksm-service-account.yaml
kubectl apply -f ksm-service.yaml

helm upgrade --install newrelic newrelic-prometheus/newrelic-prometheus-agent -f configurator-values.yaml