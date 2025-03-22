# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_03_22_164026) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "appointments", force: :cascade do |t|
    t.datetime "date"
    t.integer "status"
    t.integer "patient_id"
    t.integer "clinic_id"
    t.integer "doctor_id"
    t.string "description"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinic_id", "date", "status"], name: "index_appointments_on_clinic_id_date_status"
    t.index ["clinic_id", "date"], name: "index_appointments_on_clinic_id_and_date_not_cancelled", where: "(status <> 2)"
    t.index ["doctor_id"], name: "index_appointments_on_doctor_id"
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
  end

  create_table "clinic_users", force: :cascade do |t|
    t.bigint "clinic_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinic_id", "user_id"], name: "index_clinic_users_on_clinic_id_and_user_id", unique: true
    t.index ["clinic_id"], name: "index_clinic_users_on_clinic_id"
    t.index ["user_id"], name: "index_clinic_users_on_user_id"
  end

  create_table "clinics", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.string "website"
    t.text "description"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "diagnoses", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.integer "status", default: 1
    t.bigint "clinic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clinic_id", "name"], name: "index_diagnoses_on_clinic_id_and_name", unique: true
    t.index ["clinic_id"], name: "index_diagnoses_on_clinic_id"
  end

  create_table "doctors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "email"
    t.string "address"
    t.integer "age"
    t.integer "clinic_id"
    t.integer "user_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "preferences", default: {}
  end

  create_table "health_conditions", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_health_conditions_on_name"
  end

  create_table "health_records", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "health_condition_id", null: false
    t.string "value", default: "N/A"
    t.integer "clinic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id", "health_condition_id"], name: "index_health_records_on_patient_id_and_health_condition_id"
  end

  create_table "patient_diagnoses", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "clinic_id", null: false
    t.index ["clinic_id"], name: "index_patient_diagnoses_on_clinic_id"
    t.index ["patient_id"], name: "index_patient_diagnoses_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone_number"
    t.string "address"
    t.string "description"
    t.integer "user_id"
    t.integer "age"
    t.integer "clinic_id"
    t.integer "status", default: 0
    t.integer "gender", default: 0
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_name"], name: "index_patients_on_first_name"
    t.index ["last_name"], name: "index_patients_on_last_name"
    t.index ["phone_number"], name: "index_patients_on_phone_number"
  end

  create_table "services", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "price_type", default: 0
    t.decimal "price", precision: 10, scale: 2
    t.decimal "price_max", precision: 10, scale: 2
    t.integer "status", default: 1
    t.integer "clinic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tooth_diagnoses", force: :cascade do |t|
    t.integer "tooth_number", null: false
    t.integer "severity", default: 0
    t.bigint "diagnosis_id", null: false
    t.bigint "patient_diagnosis_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diagnosis_id"], name: "index_tooth_diagnoses_on_diagnosis_id"
    t.index ["patient_diagnosis_id"], name: "index_tooth_diagnoses_on_patient_diagnosis_id"
  end

  create_table "tooth_diagnosis_treatments", force: :cascade do |t|
    t.bigint "tooth_diagnosis_id", null: false
    t.bigint "service_id", null: false
    t.integer "status", default: 0
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_tooth_diagnosis_treatments_on_service_id"
    t.index ["tooth_diagnosis_id"], name: "index_tooth_diagnosis_treatments_on_tooth_diagnosis_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "clinic_users", "clinics"
  add_foreign_key "clinic_users", "users"
  add_foreign_key "diagnoses", "clinics"
  add_foreign_key "patient_diagnoses", "clinics"
  add_foreign_key "patient_diagnoses", "patients"
  add_foreign_key "tooth_diagnoses", "diagnoses"
  add_foreign_key "tooth_diagnoses", "patient_diagnoses"
  add_foreign_key "tooth_diagnosis_treatments", "services"
  add_foreign_key "tooth_diagnosis_treatments", "tooth_diagnoses"
end
