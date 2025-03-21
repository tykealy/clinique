class CreateToothDiagnosisTreatments < ActiveRecord::Migration[7.2]
  def change
    create_table :tooth_diagnosis_treatments do |t|
      t.references :tooth_diagnosis, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true
      t.integer :status, default: 0
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
