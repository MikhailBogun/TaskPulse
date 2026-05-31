FactoryBot.define do
  factory :task do
    association :user
    name { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    status { :pending }
    scheduled_at { 1.hour.from_now }

    trait :success do
      status { :success }
      last_run_at { 1.hour.ago }
    end

    trait :failed do
      status { :failed }
      last_run_at { 30.minutes.ago }
    end

    trait :due_now do
      scheduled_at { 5.minutes.ago }
    end
  end
end
