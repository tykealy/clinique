FactoryBot.define do
  factory :clinic do
    name { "Testing Denttal" }
    status { 'active' }
    sequence(:email) { |n| "clinic#{n}@example.com" } # Ensure unique emails
  end
end
