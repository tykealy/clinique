class AddPartialIndexToAppointments < ActiveRecord::Migration[7.2]
  def change
    add_index :appointments, [:clinic_id, :date], name: "index_appointments_on_clinic_id_and_date_not_cancelled", where: "status != '2'"
    add_index :appointments, [:clinic_id, :date, :status], name: "index_appointments_on_clinic_id_date_status"
  end
end
