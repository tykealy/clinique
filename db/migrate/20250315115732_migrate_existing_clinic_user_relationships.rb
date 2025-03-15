class MigrateExistingClinicUserRelationships < ActiveRecord::Migration[7.2]
  def up
    # First create the clinic_users table
    create_table :clinic_users do |t|
      t.references :clinic, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    add_index :clinic_users, [:clinic_id, :user_id], unique: true

    # Copy existing relationships to the new join table
    execute <<-SQL
      INSERT INTO clinic_users (clinic_id, user_id, created_at, updated_at)
      SELECT id, user_id, NOW(), NOW()
      FROM clinics
      WHERE user_id IS NOT NULL
    SQL

    # Remove the user_id column from clinics
    remove_column :clinics, :user_id, :integer
  end

  def down
    # Add back the user_id column to clinics
    add_column :clinics, :user_id, :integer

    # Copy back the first relationship for each clinic
    execute <<-SQL
      UPDATE clinics c
      SET user_id = (
        SELECT user_id
        FROM clinic_users cu
        WHERE cu.clinic_id = c.id
        LIMIT 1
      )
    SQL

    # Drop the clinic_users table
    drop_table :clinic_users
  end
end
