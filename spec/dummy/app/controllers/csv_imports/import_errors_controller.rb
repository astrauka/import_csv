module CsvImports
  class ImportErrorsController < CsvImports::BaseController
    expose(:import_errors) { csv_import.import_errors.page(params[:page]) }
  end
end
