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

        (0..6).each do |day_offset|
          date = (start_date + day_offset.days)
          hour = date.hour
          day = date.strftime('%b %d')
          expect(result[hour][day]).not_to be_empty
        end

        outside_date = start_date + 7.days
        expect(result[outside_date.hour][outside_date.strftime('%b %d')]).to be_empty
      end
    end

    describe '#weekdates' do
      it 'returns correct date structure for the week' do
        query = AppointmentQuery.new(start_date, clinic.id)
        result = query.weekdates
        expect(result).to eq([
          { date: 'Jan 01', day: 'Mon' },
          { date: 'Jan 02', day: 'Tue' },
          { date: 'Jan 03', day: 'Wed' },
          { date: 'Jan 04', day: 'Thu' },
          { date: 'Jan 05', day: 'Fri' },
          { date: 'Jan 06', day: 'Sat' },
          { date: 'Jan 07', day: 'Sun' }
        ])
      end
    end
  end
end
