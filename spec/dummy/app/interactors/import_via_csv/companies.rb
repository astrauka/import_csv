module ImportViaCsv
  class Companies
    def self.run(csv_import)
      ImportViaCsv::Objects.new(csv_import, BuildForCsvImport::Company).run
    end
  end
end
