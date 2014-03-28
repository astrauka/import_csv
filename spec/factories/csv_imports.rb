FactoryGirl.define do
  factory :csv_import do
    file { File.open Rails.root.join("../../", 'spec', 'fixtures', 'objects.csv') } # loaded from dummy app scope
  end
end
