class ClinicUser < ApplicationRecord
  belongs_to :clinic
  belongs_to :user

  validates :clinic_id, uniqueness: { scope: :user_id }
end
