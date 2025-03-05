class CreateServices < ActiveRecord::Migration[7.2]
  def change
    create_table :services do |t|
      t.string :name, null: false
      t.text :description
      t.integer :price_type, default: 0
      t.decimal :price, precision: 10, scale: 2
      t.decimal :price_max, precision: 10, scale: 2
      t.integer :status, default: '1'
      t.integer :clinic_id, null: false

      t.timestamps
    end
  end
end
