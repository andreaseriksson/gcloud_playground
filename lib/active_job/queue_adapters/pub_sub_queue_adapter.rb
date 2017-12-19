module ActiveJob
  module QueueAdapters
    class PubSubQueueAdapter
      TOPIC = 'active_job_queue'
      SUBSCRIPTION = 'active_job_subscription'

      def enqueue(job)
        topic = self.class.pubsub.topic TOPIC
        topic.publish JSON.dump(job.serialize)
      end

      def self.pubsub
        gcloud = Google::Cloud.new ENV['PROJECT_ID']
        gcloud.pubsub
      end
    end
  end
end
