class Appointment < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor
  belongs_to :clinic

  enum :status, { pending: 0, confirmed: 1, cancelled: 2 }

  def fetch_appointments_for_week(start_date)
    end_date = start_date + 6.days

    appointments = Appointment.where(date: start_date.beginning_of_day..end_date.end_of_day)

    # Initialize the structure
    calendar_data = Hash.new { |hash, key| hash[key] = Hash.new { |h, k| h[k] = [] } }

    # Populate the structure
    appointments.each do |appt|
      hour = appt.date.hour
      date = appt.date.strftime('%b %e') # Format as "Jan 7"

      calendar_data[hour][date] << {
        title: appt.title,
        doctor: "Dr. #{appt.doctor_id}", # Adjust doctor representation as needed
        time: "#{appt.date.strftime('%H:%M')} - #{(appt.date + 30.minutes).strftime('%H:%M')}"
      }
    end

    calendar_data
  end
end
