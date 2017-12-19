require 'rails_helper'

RSpec.describe VatValidator do
  subject { described_class.new(company) }
  let(:company) { Company.new(vat_number: vat_number) }
  let(:vat_number) { 'LU26375245' }

  before do
    allow_any_instance_of(VatValidator).to receive(:call_api).and_return(true)
    allow_any_instance_of(Company).to receive(:update_attribute)
  end

  it 'validates that the vat_number is present?' do
    expect(VatValidator.new(Company.new(vat_number: nil))).not_to be_valid
    expect(VatValidator.new(Company.new(vat_number: vat_number))).to be_valid
  end

  describe '#check' do
    context 'vat_number is empty' do
      let(:company) { Company.new(vat_number: nil) }

      it 'returns nil' do
        expect(subject.check).to be_nil
      end

      it 'doesnt call the api' do
        expect(subject).not_to receive :call_api
        subject.check
      end
    end

    context 'vat_number is present and valid' do
      let(:company) { Company.new(vat_number: vat_number) }

      it 'returns nil' do
        expect(subject.check).to be_nil
      end

      it 'calls the api' do
        expect(subject).to receive :call_api
        subject.check
      end

      it 'updates the company' do
        expect(company).to receive :update_attribute
        subject.check
      end
    end

    context 'vat_number is present but not valid' do
      before do
        allow_any_instance_of(VatValidator).to receive(:call_api).and_return(false)
      end

      let(:company) { Company.new(vat_number: vat_number) }

      it 'returns nil' do
        expect(subject.check).to be_nil
      end

      it 'calls the api' do
        expect(subject).to receive :call_api
        subject.check
      end

      it 'updates the company' do
        expect(company).not_to receive :update_attribute
        subject.check
      end
    end
  end
end
