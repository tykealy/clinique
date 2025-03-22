class AddClinicIdToPatientDiagnoses < ActiveRecord::Migration[7.2]
  def change
    add_reference :patient_diagnoses, :clinic, null: false, foreign_key: true
  end
end
