class CreateToothDiagnoses < ActiveRecord::Migration[7.2]
  def change
    create_table :tooth_diagnoses do |t|
      t.integer :tooth_number, null: false
      t.integer :severity, default: 0
      t.references :diagnosis, null: false, foreign_key: true
      t.references :patient_diagnosis, null: false, foreign_key: true

      t.timestamps
    end
  end
end
