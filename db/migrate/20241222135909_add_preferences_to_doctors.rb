class AddPreferencesToDoctors < ActiveRecord::Migration[7.2]
  def change
    add_column :doctors, :preferences, :json, default: {}
  end
end
