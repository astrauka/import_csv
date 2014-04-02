require 'csv'

module ImportViaCsv
  class Objects
    attr_reader :csv_import, :exception, :total_records, :failed_records

    def initialize(csv_import)
      @csv_import = csv_import

      # count of records in csv file
      @total_records = 0

      # records that failed validation during save
      @failed_records = []
    end

    def run
      begin
        import_objects
        save_importing_results

        self
      rescue Exception => e
        csv_import.mark_errored # mark errored to not keep as pending
        raise e
      end
    end

    def content
      @content ||= utf_8_encoded(csv_import.file.read)
    end

    def utf_8_encoded(file_content)
      begin
        file_content.encode("UTF-8")
      rescue Encoding::UndefinedConversionError
        file_content.force_encoding('ISO-8859-1').encode('UTF-8')
      end
    end

    def import_objects
      begin
        CSV.parse(content,
                  headers: true,
                  skip_blanks: true,
                  header_converters: [:symbol]) do |row|
          row_import = ImportViaCsv::Row.new(row).run
          @failed_records << row_import.failure if row_import.failure
          @total_records += 1
        end
      rescue CSV::MalformedCSVError => e
        @exception = e
      end
    end

    def save_importing_results
      if exception
        record_exception
      else
        record_failures
      end

      csv_import.total_count = total_records
      csv_import.save!

      csv_import.complete
    end

    def add_import_error(import_error_data)
      csv_import.import_errors.create!(import_error_data)
    end

    def record_exception
      add_import_error(
        {
          error_messages: {
            entry: ["resulted in exception"],
            exception: [exception.to_s],
          }
        }
      )
    end

    def record_failures
      failed_records.each do |object, input_values|
        add_import_error(
          {
            error_messages: object.errors.to_hash,
            input_values: input_values.to_hash,
          }
        )
      end
    end
  end
end
