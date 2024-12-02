class ChangeFromUserToPatien < ActiveRecord::Migration[7.2]
  def change
    rename_column :appointments, :user_id, :patient_id
  end
end
