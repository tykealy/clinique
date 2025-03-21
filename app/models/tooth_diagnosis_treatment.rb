class ToothDiagnosisTreatment < ApplicationRecord
  belongs_to :tooth_diagnosis
  belongs_to :treatment, class_name: 'Service', foreign_key: 'service_id'

  enum :status, {
    in_progress: 0,
    completed: 1
  }
end
