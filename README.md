# Monitoring Sidekiq with New Relic Prometheus Agent

This is a simple Ruby on Rails app that triggers a couple of sidekiq jobs. The app itself is instrumented by the New Relic Ruby APM agent. It also uses a third-party [sidekiq prometheus exporter](https://github.com/Strech/sidekiq-prometheus-exporter) that exposes a '/metrics' endpoint which is then scraped by the New Relic Prometheus Agent.

This project is based on these tutorials:
1. https://bootrails.com/blog/rails-sidekiq-tutorial/
2. https://www.digitalocean.com/community/tutorials/containerizing-a-ruby-on-rails-application-for-development-with-docker-compose

## Prerequisites:

Make sure you have the following installed:
* Ruby
```
$> ruby -v
ruby 3.2.2 // you need at least version 3
```
* Bundle
```
$> bundle -v  
Bundler version 2.4.10  
```
* PostgreSQL
```
$> psql --version  
psql (PostgreSQL) 15.4
```
* Redis
```
$> redis-cli ping // redis is a dependency of Sidekiq
PONG
```
* Colima (you can use any other Kubernetes tool of your choice)
```
$> colima --version
colima version 0.5.5
```

## Building and Running in Docker

**Note:** There is a `.env` file at the root of the project directory. In a production environment, it is not recommended to check this in version control as it may contain sensitive information.

Before you can run the application, update the license key in `config/newrelic.yml`.

To build the Docker images and create the containers, run the following command:
```
$> docker-compose up -d
```
You can now test that the app is running (WITHOUT the NR Prometheus Agent). 
1. Visit http://localhost:3000/ then click the button "Launch jobs".
2. It will then trigger the jobs and redirect you to http://localhost:3000/other/job_done page.
3. On another tab, visit http://localhost:9292/metrics - you should see the sidekiq metrics.

![alt text](/screenshots/sidekiq_flow.png)

![alt text](/screenshots/exporter_metrics.png)

To stop the containers:
```
$> docker-compose down
```

### Troubleshooting

If you encounter an error saying that the database does not exist:
```
docker-compose exec app bundle exec rails db:create db:migrate
```

If you'd like to see the logs of your containers:
```
$> docker-compose logs -f
```

## Deploying in Kubernetes

Apply all the YAML files in the k8s/ directory:
```
$> kubectl apply -f k8s
```

After making sure that all pods and deployments are available and running, test the application again following the instructions above.

## Deploying the New Relic Prometheus Agent

Before you install the agent, you need to have KSM (kube state metrics) deployed in your cluster. If you don't have it, you can apply the following YAML files in the ksm/ directory:
```
kubectl apply -f cluster-role.yaml
kubectl apply -f ksm-cluster-role-binding.yaml
kubectl apply -f ksm-cluster-role.yaml
kubectl apply -f ksm-deployment.yaml
kubectl apply -f ksm-service-account.yaml
kubectl apply -f ksm-service.yaml
```

Once that's done, modify the cluster name and license key in the `ksm/configurator-values.yaml`.
Then install the helm chart:
```
helm repo add newrelic-prometheus https://newrelic.github.io/newrelic-prometheus-configurator
helm upgrade --install newrelic newrelic-prometheus/newrelic-prometheus-agent -f configurator-values.yaml
```

## Seeing it in New Relic

You should be able to find an APM entity named  `NR Sidekiq Prometheus` (if you did not change the app name in your `newrelic.yml`).

More importantly, you should now be able to see the sidekiq metrics reporting in your New Relic account.
![alt text](/screenshots/sidekiq_metrics.png)

### Sidekiq Dashboard
In the dashboard directory, copy the sidekiq JSON and import it to your New Relic account.
![alt text](/screenshots/sidekiq_dashboard.png)
