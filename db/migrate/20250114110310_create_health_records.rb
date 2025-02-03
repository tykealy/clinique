class CreateHealthRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :health_records do |t|
      t.integer :patient_id, null: false
      t.integer :health_condition_id, null: false
      t.string :value, default: 'N/A'
      t.integer :clinic_id, null: false

      t.timestamps
    end
    add_index :health_records, [:patient_id, :health_condition_id]
  end
end
