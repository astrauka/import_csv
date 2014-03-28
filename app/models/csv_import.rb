class CsvImport < ActiveRecord::Base
  mount_uploader :file, CsvFileUploader

  has_many :importing_errors, as: :importing

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

  def self.run_importing_job(importing)
    raise "Please override me with call to importing job"
  end

  def schedule_import
    if CsvImport.delay_importing
      Admins::ImportsWorker.perform_async(id)
    else
      Admins::ImportsWorker.new.perform(id)
    end
  end

  def saved_count
    total_count - failed_count
  end

  def failed_count
    importing_errors.count
  end
end
