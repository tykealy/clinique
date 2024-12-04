FactoryBot.define do
  factory :patient do
    first_name  { "John Doe" }
    phone_number { "1234567890" }
    clinic { create(:clinic) }
  end
end
