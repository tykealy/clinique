module Admin
  class AppointmentQuery
    def initialize(start_date, clinic_id)
      @start_date = start_date
      @clinic_id = clinic_id
    end

    def fetch_appointments_for_week
      end_date = @start_date + 6.days

      appointments = Appointment.where(
        date: @start_date.beginning_of_day..end_date.end_of_day,
        clinic_id: @clinic_id
      )

      calendar = Hash.new { |h, k1| h[k1] = Hash.new { |h1, k2| h1[k2] = [] } }

      appointments.each do |appointment|
        hour = appointment.date.hour
        day = appointment.date.strftime('%b %d') # Format as "Jan 7"
        calendar[hour][day] << {
          id: appointment.id,
          title: appointment.title,
          doctor: appointment.doctor,
          time: appointment.date.strftime('%H:%M - %H:%M')
        }
      end

      calendar
    end

    def weekdates
      (0..6).map do |i|
        date = @start_date + i.days
        { date: date.strftime('%b %d'), day: date.strftime('%a') }
      end
    end
  end
end
