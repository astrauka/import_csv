class CsvImportWorker
  include Sidekiq::Worker if defined?(Sidekiq::Worker)

  def perform(csv_import_id)
    if csv_import = CsvImport.find_by(id: csv_import_id)
      csv_import.type.constantize.run_csv_import_job(csv_import)
    end
  end
end
