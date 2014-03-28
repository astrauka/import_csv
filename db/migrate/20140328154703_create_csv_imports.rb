class CreateCsvImports < ActiveRecord::Migration
  def change
    create_table :csv_imports do |t|
      t.string :file
      t.string :file_cache
      t.integer :total_count, default: 0

      t.timestamps
    end
  end
end
