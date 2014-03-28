require "import_csv/engine"
require "carrierwave"
require "state_machine"

module ImportCsv
  ### Application configuration
  DEFAULT_PARAMS = {
    csv_file_uploader_class: "CsvFileUploader",
    delay_csv_import: false,
  }

  class << self
    attr_accessor :configuration

    # Allows default params to be accessed on Progress module
    # directly to prevent chaining
    delegate(*(DEFAULT_PARAMS.keys << { to: :configuration }))

    def configure
      self.configuration ||= OpenStruct.new(DEFAULT_PARAMS)
      yield(configuration)
    end
  end
  ### END Application configuration
end
