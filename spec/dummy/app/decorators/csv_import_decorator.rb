class CsvImportDecorator < ApplicationDecorator
  def created_at
    h.l object.created_at
  end

  def path_for_status_update
    csv_imports_object_path object,
                            format: :json
  end

  def status
    object.state.titleize
  end
end
