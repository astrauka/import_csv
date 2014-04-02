require "spec_helper"

describe BuildForCsvImport::Company do
  let(:builder) { described_class.new(attributes) }
  let(:attributes) do
    {
      name: name,
      contact_email: contact_email,
      status: status_name,
      location: location_name,
    }
  end
  let(:status_name) { "Private" }
  let(:location_name) { "London" }
  let(:name) { "Cocoon" }
  let(:contact_email) { "info@example.com" }

  let(:status) { create :status, name: status_name }
  let(:location) { create :location, name: location_name }

  let(:company) { builder.company }

  describe "#assign_status" do
    let(:result) { builder.assign_status; company.status }

    context "When status found by name" do
      before { status }

      it "Then assigns status" do
        expect(result).to eq status
      end
    end

    context "When status not found by name" do
      it "Then adds error to company" do
        expect {
          result
        }.to raise_error(ActiveRecord::RecordNotFound)

        expect(company.status).to be_nil
        expect(company.errors[:base]).to have(1).item
      end
    end
  end

  describe "#assign_location" do
    let(:result) { builder.assign_location; company.location }

    context "When location exists" do
      before { location }

      it "Then assigns the location" do
        expect(result).to eq location
      end
    end

    context "When location does not exist" do
      it "Then creates new location and assigns that" do
        expect(result.name).to eq location_name
      end
    end
  end

  describe "#assign_direct_attributes" do
    let(:result) { builder.assign_direct_attributes }

    it "assigns direct attributes" do
      result
      expect(company.contact_email).to eq contact_email
    end
  end
end
