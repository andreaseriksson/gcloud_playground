class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.string :zip
      t.string :city
      t.string :phone
      t.string :email
      t.string :vat_number
      t.string :contact

      t.timestamps
    end
  end
end
