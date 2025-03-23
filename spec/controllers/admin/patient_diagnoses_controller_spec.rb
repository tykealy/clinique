require 'rails_helper'

RSpec.describe Admin::PatientDiagnosesController, type: :controller do
  let(:clinic) { create(:clinic) }
  let(:patient) { create(:patient, clinic: clinic) }
  
  # Modified to remove the clinic association if it's causing issues
  let(:user) { create(:user) }
  
  before do
    sign_in user if defined?(sign_in)
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
    
    # Properly mock the current_clinic instance variable
    controller.instance_variable_set(:@current_clinic, clinic)
    
    # Also mock the method call for good measure
    allow(controller).to receive(:current_clinic).and_return(clinic)
    
    # Mock the Appointment.for_clinic call to avoid nil error
    allow(Appointment).to receive_message_chain(:for_clinic, :confirmed_for_date, :count).and_return(0)
    # Mock the load_appointment_count method
    allow(controller).to receive(:load_appointment_count).and_return(0)
  end

  describe 'POST #create' do
    it 'creates a new patient diagnosis' do
      expect {
        post :create, params: { patient_id: patient.id }
      }.to change(PatientDiagnosis, :count).by(1)
    end
  end
end 