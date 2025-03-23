require 'rails_helper'

RSpec.describe "PatientDiagnosis Integration", type: :request do
  describe "Index page contains proper create button" do
    it "has a button that uses turbo_method: :post" do
      # Get the file contents directly to verify the button configuration
      view_file = File.join(Rails.root, 'app', 'views', 'admin', 'patient_diagnoses', 'index.html.erb')
      expect(File.exist?(view_file)).to be true
      
      file_content = File.read(view_file)
      
      # Check for link_to with data-turbo-method: :post
      expect(file_content).to include('data: { turbo_method: :post }')
      
      # Check for the right controller path
      expect(file_content).to include('admin_patient_patient_diagnoses_path')
      
      # Check presence of New Diagnosis button
      expect(file_content).to include('New Diagnosis')
    end
  end
end 