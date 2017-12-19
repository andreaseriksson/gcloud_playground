desc 'Run task queue worker'
task run_worker: :environment do
  ActiveJob::Workers::PubSubQueueWorker.run_worker!
end
