class CreateDiagnoses < ActiveRecord::Migration[7.2]
  def change
    create_table :diagnoses do |t|
      t.string :name
      t.string :code
      t.string :description
      t.integer :status, default: 1
      t.references :clinic, null: false, foreign_key: true
      t.timestamps
    end
    add_index :diagnoses, [:clinic_id, :name], unique: true
  end
end
