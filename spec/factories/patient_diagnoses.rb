FactoryBot.define do
  factory :patient_diagnosis do
    association :patient
    association :clinic
    description { "Sample diagnosis description" }
  end
end 