class Diagnosis < ApplicationRecord
  belongs_to :clinic
  validates :name, presence: true
  validates :code, presence: true, uniqueness: { scope: :clinic_id }
  validates :status, presence: true

  enum :status, { inactive: 0, active: 1 }

  scope :active, -> { where(status: :active) }
  scope :inactive, -> { where(status: :inactive) }
end
