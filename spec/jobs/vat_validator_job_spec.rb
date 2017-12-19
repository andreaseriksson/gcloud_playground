require 'rails_helper'

RSpec.describe VatValidatorJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job)   { described_class.perform_later(id) }
  let(:id)        { 1 }
  let(:company)   { Company.new(id: 1) }
  let(:validator) { VatValidator.new(company) }
  before { allow(Company).to receive(:find) { company } }

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class).with(id).on_queue('default')
  end

  it 'is in default queue' do
    expect(VatValidatorJob.new.queue_name).to eq('default')
  end

  it 'executes perform' do
    expect(VatValidator).to receive(:new).with(company).and_return(validator)
    expect(validator).to receive(:check)
    perform_enqueued_jobs { job }
  end

  context 'when the api does not respond' do
    before do
      allow_any_instance_of(VatValidator).to receive(:check).and_raise(VatValidator::NoResultsError)
    end

    it 'handles no results error' do
      perform_enqueued_jobs do
        expect_any_instance_of(VatValidatorJob).to receive(:retry_job).with(wait: 5.minutes, queue: :default, retries_count: 0)
        job
      end
    end

    it 'retries two times' do
      perform_enqueued_jobs { job }
      expect(Company).to have_received(:find).with(id).exactly(3).times
    end
  end
end
