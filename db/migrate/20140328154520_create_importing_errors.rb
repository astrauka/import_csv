class CreateImportingErrors < ActiveRecord::Migration
  def change
    create_table :import_errors do |t|
      t.references :csv_import
      t.text :error_messages
      t.text :input_values

      t.timestamps
    end
  end
end
