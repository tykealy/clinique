FactoryBot.define do
  factory :clinic_user do
    association :user
    association :clinic
  end
end
