class CsvImport < ActiveRecord::Base
  # configurable uploader
  mount_uploader :file, ImportCsv.csv_file_uploader_class.constantize

  has_many :import_errors, as: :csv_import

  validates :file, presence: true

  scope :most_recent, -> { order(created_at: :desc) }

  state_machine :state, initial: :pending do
    event :complete do
      transition pending: :completed
    end

    event :mark_errored do
      transition pending: :errored
    end
  end

  def self.run_csv_import_job(csv_import)
    raise "Please override me with call to csv import job"
  end

  def schedule_import
    if ImportCsv.delay_csv_import
      import_async
    else
      import_sync
    end
  end

  def import_async
    raise "Please define asynchronous importing"
  end

  def import_sync
    raise "Please define synchronous importing"
  end

  def saved_count
    total_count - failed_count
  end

  def failed_count
    import_errors.count
  end
end
