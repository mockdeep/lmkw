web: bundle exec puma -C config/puma.rb
critical_worker: bundle exec sidekiq -C config/sidekiq_critical.yml -q critical
default_worker: bundle exec sidekiq -C config/sidekiq_default.yml -q critical -q default
slow_worker: bundle exec sidekiq -C config/sidekiq_slow.yml -q critical -q default -q slow
release: bundle exec rails db:migrate
