FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    confirmed_at { Time.current }
    plan { :free }

    trait :trial do
      plan { :trial }
      trial_ends_at { 7.days.from_now }
    end

    trait :pro do
      plan { :pro }
    end

    trait :enterprise do
      plan { :enterprise }
    end

    trait :trial_expired do
      plan { :trial }
      trial_ends_at { 1.day.ago }
    end

    trait :in_grace_period do
      plan { :free }
      grace_period_ends_at { 2.days.from_now }
    end
  end
end
