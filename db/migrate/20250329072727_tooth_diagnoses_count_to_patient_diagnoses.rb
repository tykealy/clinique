class ToothDiagnosesCountToPatientDiagnoses < ActiveRecord::Migration[7.2]
  def change
    add_column :patient_diagnoses, :tooth_diagnoses_count, :integer, default: 0
  end
end
