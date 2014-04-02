require "spec_helper"

describe ImportViaCsv::Objects do
  let(:importer) { described_class.new(csv_import, build_strategy) }
  let(:csv_import) do
    i = create :csv_import
    i.stub(:file) { double :file,
                           read: content,
                           remove_previously_stored_files_after_update: true }
    i
  end
  let(:content) { lines.join("\n") }
  let(:lines) { [headers, line1, line2, line3].compact }
  let(:headers) do
    %W{
Name,Owner_name
}
  end
  let(:line1) do
    %W{
Aroma,"Teodor Therapy"
}
  end
  let(:line2) { nil }
  let(:line3) { nil }

  let(:built_object) { OpenStruct.new errors: { key: :value },
                                      valid?: true,
                                      save: false }
  let(:build_strategy) { double :build_strategy,
                                build: built_object }

  describe "#run" do
    context "When importing ends up in exception" do
      let(:exception) { Exception.new("aa") }
      before do
        expect(importer).to receive(:import_objects).and_raise(exception)
      end

      it "Then marks import errored" do
        begin
          importer.run
        rescue Exception => e
          raise e unless e == exception
        end

        expect(importer.csv_import).to be_errored
      end
    end

    context "When importing succeeds" do
      it "Then completes the csv_import" do
        expect {
          importer.run
        }.to change(CsvImport, :count).by 1
        expect(importer.csv_import).to be_completed
        expect(importer.csv_import).to have(1).import_error
      end
    end
  end

  describe "#content" do
    let(:result) { importer.content }

    it "returns file_content" do
      expect(result).to eq content
    end
  end

  describe "#import_objects" do
    let(:result) { importer.import_objects }
    let(:run_result) { double :result, failure: "failure" }

    context "When importing results in failure" do
      before do
        expect(ImportViaCsv::Row).to receive(:new) {
          double :importer,
                 run: run_result
        }
      end

      it "imports the objects from csv, updates total count and failed records" do
        result
        expect(importer.failed_records).to eq ["failure"]
        expect(importer.total_records).to eq 1
      end
    end

    context "When importing results in malformed csv error" do
      before do
        expect(ImportViaCsv::Row).to receive(:new).and_raise(CSV::MalformedCSVError)
      end

      it "Then records exception" do
        result
        expect(importer.exception).to be_present
        expect(importer.total_records).to eq 0
      end
    end
  end

  describe "#save_importing_results" do
    let(:result) { importer.save_importing_results }
    let(:resulting_csv_import) { importer.csv_import }
    let(:first_import_error) { resulting_csv_import.import_errors.first }

    context "When import completes" do
      let(:built_object) { OpenStruct.new errors: { key: :value} }
      let(:input_values) { Hash[:input, :values] }
      let(:failed_records) do
       [
         [built_object, input_values],
       ]
      end
      let(:total_records) { 1 }

      before do
        importer.stub(:failed_records) { failed_records }
        importer.stub(:total_records) { total_records }
      end

      it "updates csv_import with counts, errors and moves to complete state" do
        result
        expect(first_import_error.error_messages).to be_present
        expect(first_import_error.input_values).to be_present
        expect(resulting_csv_import.total_count).to eq total_records
        expect(resulting_csv_import).to be_completed
      end
    end

    context "When importing results in malformed csv error" do
      before do
        importer.stub(:exception) { CSV::MalformedCSVError }
      end

      it "Then records exception" do
        result
        expect(first_import_error).to be_present
        expect(first_import_error.error_messages[:entry]).to eq ["resulted in exception"]
      end
    end
  end
end
