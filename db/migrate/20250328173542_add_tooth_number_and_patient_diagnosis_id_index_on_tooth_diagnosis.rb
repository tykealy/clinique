class AddToothNumberAndPatientDiagnosisIdIndexOnToothDiagnosis < ActiveRecord::Migration[7.2]
  def change
    add_index :tooth_diagnoses, [:tooth_number, :patient_diagnosis_id, :diagnosis_id], unique: true
  end
end
