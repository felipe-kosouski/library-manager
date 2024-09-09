FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    role { 'member' }

    trait :librarian do
      role { 'librarian' }
    end
  end
end