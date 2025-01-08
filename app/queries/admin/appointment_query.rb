module Admin
  class AppointmentQuery
    def initialize(start_date, clinic_id, show_cancelled: false)
      @start_date = start_date
      @clinic_id = clinic_id
      @show_cancelled = show_cancelled
    end

    def fetch_appointments_for_week
      appointments = Appointment
                     .includes(:doctor, :patient)
                     .select(
                       "appointments.id AS appointment_id,
                        appointments.title AS appointment_title,
                        appointments.date AS appointment_date,
                        appointments.status AS appointment_status,
                        doctors.id AS doctor_id,
                        doctors.preferences ->> 'font_color' AS doctor_font_color,
                        doctors.preferences ->> 'bg_color' AS doctor_bg_color,
                        patients.id AS patient_id,
                        patients.first_name AS patient_firstname,
                        patients.last_name AS patient_lastname"
                     )
                     .where(
                       date: @start_date.beginning_of_day..(@start_date + 6.days).end_of_day,
                       clinic_id: @clinic_id

                     )
                     .left_outer_joins(:doctor, :patient)
      appointments = appointments.where.not(status: :cancelled) unless @show_cancelled

      calendar = Hash.new { |h, k1| h[k1] = Hash.new { |h1, k2| h1[k2] = [] } }

      appointments.each do |appointment|
        hour = appointment.appointment_date.hour
        day = appointment.appointment_date.to_date

        calendar[hour][day] << {
          id: appointment.appointment_id,
          title: appointment.appointment_title,
          patient: "#{appointment.patient_firstname} #{appointment.patient_lastname}",
          time: appointment.appointment_date.strftime('%H:%M - %H:%M'),
          font_color: appointment.doctor_font_color,
          bg_color: appointment.doctor_bg_color,
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
