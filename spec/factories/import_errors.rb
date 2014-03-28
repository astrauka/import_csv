FactoryGirl.define do
  factory :import_error do
    association :csv_import, strategy: :build

    error_messages do
      { name: "Is already taken" }
    end

    input_values do
      { name: "Company Name" }
    end
  end
end
