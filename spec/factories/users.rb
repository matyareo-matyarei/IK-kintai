FactoryBot.define do
  factory :user do
    full_name              {"水野"}
    email                 {Faker::Internet.free_email}
    password              {Faker::Internet.password(min_length: 6)}
    password_confirmation {password}
    full_part             {true}
    affiliation_id        {Faker::Number.between(from: 2, to: 5)}
  end
end
