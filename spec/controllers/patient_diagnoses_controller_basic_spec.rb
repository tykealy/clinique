require 'rails_helper'

RSpec.describe "PatientDiagnoses Controller Functionality", type: :controller do
  it "has a create method" do
    expect(Admin::PatientDiagnosesController.instance_methods).to include(:create)
  end
  
  it "has routes for the create action" do
    routes = Rails.application.routes.routes.map { |r| 
      {
        verb: r.verb,
        path: r.path.spec.to_s,
        controller: r.defaults[:controller],
        action: r.defaults[:action]
      } 
    }.select { |r| r[:controller] == "admin/patient_diagnoses" }
    
    create_route = routes.find { |r| r[:action] == "create" }
    expect(create_route).not_to be_nil
    expect(create_route[:verb]).to eq("POST")
  end
end 