class ToothDiagnosis < ApplicationRecord
  belongs_to :patient_diagnosis

  delegate :clinic, to: :patient_diagnosis

  belongs_to :diagnosis
  has_many :tooth_diagnosis_treatments, dependent: :destroy

  validates :tooth_number, presence: true,
                           numericality: { only_integer: true },
                           inclusion: { in: 11..48 } # FDI tooth notation

  validates :diagnosis_id, uniqueness: { scope: %i[tooth_number patient_diagnosis_id diagnosis_id] }

  enum :severity, {
    mild: 0,
    moderate: 1,
    severe: 2
  }

  accepts_nested_attributes_for :tooth_diagnosis_treatments,
                                allow_destroy: true,
                                reject_if: :all_blank
end
