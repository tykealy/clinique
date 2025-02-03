class CreateHealthConditions < ActiveRecord::Migration[7.2]
  def change
    create_table :health_conditions do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :health_conditions, :name
  end
end
