json.extract! company, :id, :name, :address, :zip, :city, :phone, :email, :vat_number, :contact, :created_at, :updated_at
json.url company_url(company, format: :json)
