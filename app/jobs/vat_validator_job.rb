class VatValidatorJob < ApplicationJob
  include Retryable

  queue_as :default

  rescue_from VatValidator::NoResultsError do
    retry_job wait: wait.minutes, queue: :default, retries_count: retries_count if retries_count < 2
  end

  def perform(company_id)
    company = Company.find(company_id)
    VatValidator.new(company).check
  end
end
