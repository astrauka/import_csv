class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.references :status, index: true
      t.references :location, index: true
      t.string :contact_email

      t.timestamps
    end
  end
end
