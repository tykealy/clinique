class CreateClinics < ActiveRecord::Migration[7.2]
  def change
    create_table :clinics do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :email
      t.string :website
      t.text :description
      t.integer :status, default: 0
      t.integer :user_id
      t.timestamps
    end
  end
end
