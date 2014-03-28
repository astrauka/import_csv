class ImportError < ActiveRecord::Base
  belongs_to :csv_import, polymorphic: true

  serialize :error_messages, Hash
  serialize :input_values, Hash

  def name
    input_values[:name]
  end

  def error_message_for_display
    error_messages.map { |k, v| "#{k}: #{v.join(", ")}" }
                  .join("; ")
  end
end
