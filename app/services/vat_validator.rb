class VatValidator
  class NoResultsError < StandardError; end

  include ActiveModel::Validations

  URL = 'http://apilayer.net/api/validate'

  validates :vat_number, presence: true

  attr_reader :vat_number
  attr_accessor :vat_is_valid

  def initialize(company)
    @company      = company
    @vat_number   = company.vat_number
    @vat_is_valid = false
  end

  def check
    return unless valid?

    vat_is_valid = call_api
    update_company if vat_is_valid
  end

  private

  def call_api
    response = HTTParty.get URL, vat_number: vat_number, secret_key: ENV['VATLAYER_SECRET_KEY']

    case response.code
    when 200 then
      JSON.parse(response.body)['valid']
    else
      raise NoResultsError
    end
  end

  def update_company
    @company.update_attribute :vat_validated_at, Time.current
  end
end
