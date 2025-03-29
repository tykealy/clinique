class ToothDiagnosisTreatmentsCountToToothDiagnoses < ActiveRecord::Migration[7.2]
  def change
    add_column :tooth_diagnoses, :tooth_diagnosis_treatments_count, :integer, default: 0
  end
end
