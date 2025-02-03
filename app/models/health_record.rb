class HealthRecord < ApplicationRecord
  belongs_to :patient
  belongs_to :health_condition
  belongs_to :clinic

  # validates :patient_id, uniqueness: { scope: %i[health_condition_id clinic_id] }
end
