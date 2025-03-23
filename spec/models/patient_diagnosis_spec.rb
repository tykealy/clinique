require 'rails_helper'

RSpec.describe PatientDiagnosis, type: :model do
  describe 'creation' do
    let(:clinic) { create(:clinic) }
    let(:patient) { create(:patient) }
    
    it 'creates a valid patient diagnosis' do
      patient_diagnosis = PatientDiagnosis.new(
        patient: patient,
        clinic: clinic
      )
      expect(patient_diagnosis).to be_valid
    end
  end
end 