require "spec_helper"

describe ImportViaCsv::Row do
  let(:importer) { described_class.new(row, build_strategy) }
  let(:row) do
    { name: "name" }
  end
  let(:built_object) { OpenStruct.new(errors: errors) }
  let(:errors) { [] }
  let(:build_strategy) { double :build_strategy,
                                build: built_object }

  describe "#run" do
    let(:failure) { importer.run.failure }

    context "When object could not be saved" do
      let(:errors) { ["error"] }

      it "Then records failure" do
        expect(failure).to be_present
      end
    end

    context "When object got persisted" do
      before do
        expect(built_object).to receive(:valid?) { true }
        expect(built_object).to receive(:save) { true }
      end

      it "Then does not record failure" do
        expect(failure).to be_nil
      end
    end
  end
end
