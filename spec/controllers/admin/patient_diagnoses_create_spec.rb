require 'rails_helper'

RSpec.describe Admin::PatientDiagnosesController, type: :controller do
  describe "#create method" do
    it "creates a new PatientDiagnosis" do
      # Create test objects
      clinic = create(:clinic)
      patient = create(:patient, clinic: clinic)
      
      # Call the method directly without going through the full request cycle
      controller_instance = Admin::PatientDiagnosesController.new
      
      # Set up the controller instance
      controller_instance.instance_variable_set(:@current_clinic, clinic)
      controller_instance.instance_variable_set(:@patient, patient)
      controller_instance.params = ActionController::Parameters.new(patient_id: patient.id)
      
      # Stub the redirect method
      allow(controller_instance).to receive(:redirect_to)
      
      # Stub the URL helpers
      allow(controller_instance).to receive(:edit_admin_patient_patient_diagnosis_path).and_return("/mock/path")
      allow(controller_instance).to receive(:flash).and_return({})
      
      # Manually check if the create method works - don't use change here
      # to avoid complications with controller setup
      pre_count = PatientDiagnosis.count
      
      # Call the method
      controller_instance.create
      
      # Check that a record was created
      expect(PatientDiagnosis.count).to eq(pre_count + 1)
      
      # Verify the created object has the right attributes
      new_diagnosis = PatientDiagnosis.last
      expect(new_diagnosis.patient_id.to_s).to eq(patient.id.to_s)
      expect(new_diagnosis.clinic_id.to_s).to eq(clinic.id.to_s)
    end
  end
end 