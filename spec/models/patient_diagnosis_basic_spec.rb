require 'rails_helper'

RSpec.describe "PatientDiagnosis Functionality", type: :model do
  it "exists as a class" do
    expect(defined?(PatientDiagnosis)).to eq("constant")
  end
  
  it "responds to expected attributes" do
    model = PatientDiagnosis.new
    expect(model).to respond_to(:patient)
    expect(model).to respond_to(:clinic)
    expect(model).to respond_to(:description)
  end
end 