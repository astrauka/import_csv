require "spec_helper"

describe ImportViaCsv::Companies do
  let(:importer) { described_class.run(csv_import) }

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
Name,Status,Location,Contact email
}
  end
  let(:line1) do
    %W{
Aroma,Private,London,email@example.com
}
  end
  let(:line2) { nil }
  let(:line3) { nil }

  let!(:status) { create :status, name: "Private" }

  describe "#run" do
    let(:result) { importer.run }

    it "imports company from csv" do
      expect{
        result
      }.to change(Company, :count).by 1
    end
  end
end
