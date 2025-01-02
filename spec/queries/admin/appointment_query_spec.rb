require 'rails_helper'

module Admin
  RSpec.describe AppointmentQuery do
    let!(:clinic) { create(:clinic, email: "sdfsd@gmail.com") }
    let!(:patient) { create(:patient, clinic: clinic) }
    let!(:doctor) { create(:doctor, clinic: clinic) }
    let!(:start_date) { Time.zone.local(2024, 1, 1, 8) } # Jan 1, 2024 at 8:00 AM
    let!(:appointments) {create :appointment, :weekly,
      start_date: start_date,
      doctor: doctor,
      clinic: clinic,
      patient: patient}

    describe '#fetch_appointments_for_week' do
      it 'returns appointments within the week for the specified clinic' do
        query = AppointmentQuery.new(start_date, clinic.id)
        result = query.fetch_appointments_for_week

        # (0..6).each do |day_offset|
        #   date = (start_date + day_offset.days)
        #   hour = date.hour
        #   day = date.to_date
        #   expect(result[hour][day]).not_to be_empty
        # end

        # outside_date = start_date + 7.days
        # expect(result[outside_date.hour][outside_date.strftime('%b %d')]).to be_empty
        p result
      end
    end

    describe '#weekdates' do
      it 'returns correct date structure for the week' do
        query = AppointmentQuery.new(start_date, clinic.id)
        result = query.weekdates
        expect(result).to eq([
          { date: start_date, day: 'Mon', display_date: 'Jan 01' },
          { date: start_date + 1.day, day: 'Tue', display_date: 'Jan 02' },
          { date: start_date + 2.days, day: 'Wed', display_date: 'Jan 03' },
          { date: start_date + 3.days, day: 'Thu', display_date: 'Jan 04' },
          { date: start_date + 4.days, day: 'Fri', display_date: 'Jan 05' },
          { date: start_date + 5.days, day: 'Sat', display_date: 'Jan 06' },
          { date: start_date + 6.days, day: 'Sun', display_date: 'Jan 07' }
        ])
      end
    end
  end
end
