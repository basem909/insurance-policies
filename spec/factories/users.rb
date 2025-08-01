FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    trait :admin    do; role { :admin }    end
    trait :operator do; role { :operator } end
    trait :client   do; role { :client }   end
  end
end
