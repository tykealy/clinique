# db/migrate/XXXXXXXXXX_remove_index_appointments_on_clinic_id_and_date.rb
class RemoveIndexAppointmentsOnClinicIdAndDate < ActiveRecord::Migration[6.0]
  def change
    remove_index :appointments, name: "index_appointments_on_clinic_id_and_date"
  end
end
