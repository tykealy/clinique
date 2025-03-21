class CreatePatientDiagnoses < ActiveRecord::Migration[7.2]
  def change
    create_table :patient_diagnoses do |t|
      t.references :patient, null: false, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
