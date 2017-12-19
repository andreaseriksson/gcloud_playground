module ActiveJob
  module Workers
    class PubSubQueueWorker
      ADAPTER = ActiveJob::QueueAdapters::PubSubQueueAdapter

      def self.run_worker!
        topic        = ADAPTER.pubsub.topic ADAPTER::TOPIC
        subscription = topic.subscription ADAPTER::SUBSCRIPTION

        topic.subscribe ADAPTER::SUBSCRIPTION unless subscription.exists?

        subscription.listen autoack: true do |message|
          ActiveJob::Base.execute message
        end
      end
    end
  end
end
