class CreatePatients < ActiveRecord::Migration[7.2]
  def change
    create_table :patients do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_number
      t.string :address
      t.string :description
      t.integer :user_id
      t.integer :age
      t.integer :clinic_id
      t.integer :status, default: 0
      t.integer :gender, default: 0
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
