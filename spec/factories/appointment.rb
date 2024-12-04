FactoryBot.define do
  factory :appointment do
    title { "Checkup" }
    date { Date.today }
    status { "pending" }
    association :clinic
    association :doctor
    association :patient

    transient do
      start_date { Date.today }
      days_count { 7 } # Number of days to span
    end


    trait :weekly do
      after(:create) do |appointment, evaluator|
        puts "Creating weekly appointments starting from #{evaluator.start_date}"
        puts "Doctor: #{evaluator.doctor.id}, Clinic: #{evaluator.clinic.id}, Patient: #{evaluator.patient.id}"
        (0...evaluator.days_count).each do |day_offset|
          FactoryBot.create(:appointment,
                                              date: evaluator.start_date + day_offset.days,
                                              doctor: evaluator.doctor,
                                              clinic: evaluator.clinic,
                                              patient: evaluator.patient)
        end
      end
    end
  end
end
