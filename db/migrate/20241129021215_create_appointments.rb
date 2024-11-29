class CreateAppointments < ActiveRecord::Migration[7.2]
  def change
    create_table :appointments do |t|
      t.datetime :date
      t.integer :status
      t.integer :user_id
      t.integer :clinic_id
      t.integer :doctor_id
      t.string :description
      t.string :title
      t.timestamps
    end
  end
end
