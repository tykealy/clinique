class Appointment < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor
  belongs_to :clinic

  enum :status, { confirmed: 1, pending: 0, cancelled: 2 }

  scope :for_clinic, -> (clinic) { where(clinic_id: clinic.id) }
  scope :on_date, -> (date) { where(date: date.all_day) }
  scope :with_status, -> (status) { where(status: status) }

  scope :confirmed_for_date, -> (date) { on_date(date).with_status(:confirmed) }
end
