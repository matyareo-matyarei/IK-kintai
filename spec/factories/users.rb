FactoryBot.define do
  factory :user do
    full_name { '水野' }
    email                 { Faker::Internet.free_email }
    password              { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
    full_part             { Faker::Boolean.boolean }
    affiliation_id        { Faker::Number.within(range: 2..5) }
  end
end
