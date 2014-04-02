class Company < ActiveRecord::Base
  belongs_to :status
  belongs_to :location

  validates :name, presence: true
end
