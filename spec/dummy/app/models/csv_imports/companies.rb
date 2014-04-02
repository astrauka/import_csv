module CsvImports
  class Companies < ::CsvImport
    def self.run_csv_import_job(csv_import)
      ImportViaCsv::Companies.new(csv_import).run
    end
  end
end
