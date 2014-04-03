module CsvImports
  class Company < ::CsvImport
    def build_strategy
      BuildForCsvImport::Company
    end
  end
end
