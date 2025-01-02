module Admin
  class AppointmentQuery
    def initialize(start_date, clinic_id)
      @start_date = start_date
      @clinic_id = clinic_id
    end

    def fetch_appointments_for_week
      appointments = Appointment
                     .joins('LEFT JOIN doctors ON appointments.doctor_id = doctors.id')
                     .joins('LEFT JOIN patients ON appointments.patient_id = patients.id')
                     .select(
                       "appointments.id AS appointment_id,
                        appointments.title AS appointment_title,
                        appointments.date AS appointment_date,
                        appointments.status AS appointment_status,
                        doctors.id AS doctor_id,
                        doctors.preferences as doctor_preferences,
                        patients.id AS patient_id,
                        patients.first_name AS patient_firstname,
                        patients.last_name AS patient_lastname"
                     )
                     .where(
                       date: @start_date.beginning_of_day..(@start_date + 6.days).end_of_day,
                       clinic_id: @clinic_id
                     )

      calendar = Hash.new { |h, k1| h[k1] = Hash.new { |h1, k2| h1[k2] = [] } }

      appointments.each do |appointment|
        doctor_preferences = JSON.parse(appointment.doctor_preferences || '{}')
        hour = appointment.appointment_date.hour
        day = appointment.appointment_date.to_date

        calendar[hour][day] << {
          id: appointment.appointment_id,
          title: appointment.appointment_title,
          patient: "#{appointment.patient_firstname} #{appointment.patient_lastname}",
          time: appointment.appointment_date.strftime('%H:%M - %H:%M'),
          font_color: doctor_preferences['font_color'],
          bg_color: doctor_preferences['bg_color'],
          status: appointment.appointment_status
        }
      end

      calendar
    end

    def weekdates
      (0..6).map do |i|
        date = @start_date + i.days
        {
          date: date, # Store as a full Date object
          display_date: date.strftime('%b %d'), # For display purposes
          day: date.strftime('%a')
        }
      end
    end
  end
end
