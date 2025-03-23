require 'rails_helper'

RSpec.describe "Patient Diagnoses View", type: :view do
  describe "index.html.erb" do
    it "contains a button that triggers a POST request" do
      # Get the file contents directly to avoid complex rendering
      view_file = File.join(Rails.root, 'app', 'views', 'admin', 'patient_diagnoses', 'index.html.erb')
      expect(File.exist?(view_file)).to be true
      
      file_content = File.read(view_file)
      
      # Check for link_to with data-turbo-method: :post
      expect(file_content).to include('link_to')
      expect(file_content).to include('turbo_method: :post')
      
      # Check presence of New Diagnosis button
      expect(file_content).to include('New Diagnosis')
    end
  end
end 