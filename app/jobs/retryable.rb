module Retryable
  extend ActiveSupport::Concern

  included do
    attr_accessor :retries_count, :wait
  end

  def initialize(*arguments)
    super
    @retries_count ||= 0
    @wait ||= 5
  end

  def deserialize(job_data)
    super
    @retries_count = job_data['retries_count'] || 0
    @wait = job_data['wait'] || 0
  end

  def serialize
    super.merge('retries_count' => retries_count, 'wait' => wait)
  end

  def retry_job(options)
    @retries_count = retries_count + 1
    @wait = wait + 5
    super(options.merge(retries_count: retries_count, wait: wait.minutes))
  end
end
