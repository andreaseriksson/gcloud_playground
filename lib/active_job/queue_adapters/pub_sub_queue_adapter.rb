module ActiveJob
  module QueueAdapters
    class PubSubQueueAdapter
      TOPIC = 'active_job_queue'
      SUBSCRIPTION = 'active_job_subscription'

      def enqueue(job)
        topic = self.class.pubsub.topic TOPIC
        topic.publish JSON.dump(job.serialize)
      end

      def self.run_worker!
        topic        = pubsub.topic TOPIC
        subscription = topic.subscription SUBSCRIPTION

        topic.subscribe SUBSCRIPTION unless subscription.exists?

        subscription.listen autoack: true do |message|
          ActiveJob::Base.execute message
        end
      end

      private

      def self.pubsub
        gcloud = Google::Cloud.new ENV['PROJECT_ID']
        gcloud.pubsub
      end
    end
  end
end
