module Admin
  class TransformAppointment
    def initialize(appointments)
      @appointments = appointments
    end

    def call
      transform_to_calendar_format
    end

    def transform_to_calendar_format
      calendar_data = Hash.new { |hash, key| hash[key] = Hash.new { |h, k| h[k] = [] } }

      # Populate the structure
      @appointments.each do |appt|
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
end
