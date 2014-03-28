require "spec_helper"

describe CsvImport do
  describe "#saved_count" do
    let!(:csv_import) { create :csv_import,
                               total_count: 3 }
    let!(:import_error) { create :import_error, csv_import: csv_import }
    let(:result) { csv_import.saved_count }

    it "returns how many records got saved to database" do
      expect(result).to eq 2
    end
  end
end
