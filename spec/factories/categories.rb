FactoryBot.define do
  factory :category do
    association :user
    name { Faker::Lorem.unique.word.capitalize }
    color { '#6366f1' }
  end
end
