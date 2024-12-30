class AddPatientIndex < ActiveRecord::Migration[7.2]
  def change
    add_index :patients, :first_name
    add_index :patients, :last_name
    add_index :patients, :phone_number
  end
end
