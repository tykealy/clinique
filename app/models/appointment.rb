class Appointment < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor
  belongs_to :clinic

  enum :status, { pending: 0, confirmed: 1, canceled: 2 }
end
