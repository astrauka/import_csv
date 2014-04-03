require "spec_helper"

describe "Importing companies via csv" do
  context "When import fails" do
    it "Then displays failed result" do
      visit import_form_csv_imports_companies_path
      upload_csv_file

      expect_to_see "scheduled"
      expect_to_see "Completed"
      expect_to_see "1failed"

      click_on "1failed"
      expect_to_see "Status was not found"
    end
  end

  private
  def upload_csv_file
    attach_file "csv_import_file", Rails.root.join("../../", 'spec', 'fixtures', 'objects.csv')
    click_on "Import"
  end
end
