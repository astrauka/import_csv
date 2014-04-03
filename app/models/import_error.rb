class ImportError < ActiveRecord::Base
  belongs_to :csv_import

  serialize :error_messages, Hash
  serialize :input_values, Hash

  def name
    input_values[:name]
  end
end
