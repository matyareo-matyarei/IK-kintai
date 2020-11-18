FactoryBot.define do
  factory :attendance do
    association :user
    work_place_id          { Faker::Number.within(range: 2..6) }
    work_days              { Faker::Date.in_date_period(year: 2020, month: 11) }
    in_out                 { Faker::Boolean.boolean }
    work_time              { Faker::Time.between_dates(from: Date.today - 1, to: Date.today, period: :all, format: :short) }
    carfare { Faker::Number.within(range: 0..5000) }
  end
end
