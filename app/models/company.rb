class Company < ApplicationRecord
  after_save :validate_vat

  private

  def validate_vat
    VatValidatorJob.perform_later(id)
  end
end
