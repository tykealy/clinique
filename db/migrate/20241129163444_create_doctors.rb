class CreateDoctors < ActiveRecord::Migration[7.2]
  def change
    create_table :doctors do |t|
      t.string :first_name
      t.string :last_namey
      t.string :phone_number
      t.string :email
      t.string :address
      t.integer :age
      t.integer :clinic_id
      t.integer :user_id
      t.timestamps
    end
  end
end
