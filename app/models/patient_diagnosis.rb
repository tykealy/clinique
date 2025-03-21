class PatientDiagnosis < ApplicationRecord
  belongs_to :patient

  delegate :clinic, to: :patient
  has_many :tooth_diagnoses, dependent: :destroy
  has_many :tooth_diagnosis_treatments, through: :tooth_diagnoses

  validates :description, presence: true

  accepts_nested_attributes_for :tooth_diagnoses,
                                allow_destroy: true,
                                reject_if: :all_blank
end
