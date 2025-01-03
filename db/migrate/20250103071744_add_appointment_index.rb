class AddAppointmentIndex < ActiveRecord::Migration[7.2]
  def change
    add_index :appointments, [:clinic_id, :date]
    add_index :appointments, :doctor_id
    add_index :appointments, :patient_id
  end
end
