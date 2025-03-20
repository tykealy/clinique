class MigrateExistingClinicUserRelationships < ActiveRecord::Migration[7.2]
  def up
    # First create the clinic_users table
    unless table_exists?(:clinic_users)
      create_table :clinic_users do |t|
        t.references :clinic, null: false, foreign_key: true
        t.references :user, null: false, foreign_key: true
        t.timestamps
      end
    end
    unless index_exists?(:clinic_users, [:clinic_id, :user_id], unique: true)
      add_index :clinic_users, [:clinic_id, :user_id], unique: true
    end

    # Copy existing relationships to the new join table
    if column_exists?(:clinics, :user_id)
      execute <<-SQL
        INSERT INTO clinic_users (clinic_id, user_id, created_at, updated_at)
        SELECT id, user_id, NOW(), NOW()
      FROM clinics
      WHERE user_id IS NOT NULL
      SQL
    end

    # Remove the user_id column from clinics
    if column_exists?(:clinics, :user_id)
      remove_column :clinics, :user_id, :integer
    end
  end

  def down
    # Add back the user_id column to clinics
    unless column_exists?(:clinics, :user_id)
      add_column :clinics, :user_id, :integer
    end

    # Copy back the first relationship for each clinic
    if table_exists?(:clinic_users)
      execute <<-SQL
        UPDATE clinics c
      SET user_id = (
        SELECT user_id
        FROM clinic_users cu
        WHERE cu.clinic_id = c.id
        LIMIT 1
      )
      SQL
    end

    # Drop the clinic_users table
    drop_table :clinic_users if table_exists?(:clinic_users)
  end
end
