class PatientDiagnosis < ApplicationRecord
  belongs_to :patient
  belongs_to :clinic
  has_many :tooth_diagnoses, dependent: :destroy
  has_many :tooth_diagnosis_treatments, through: :tooth_diagnoses

  accepts_nested_attributes_for :tooth_diagnoses,
                                allow_destroy: true,
                                reject_if: :all_blank
end
