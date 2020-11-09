FactoryBot.define do
  factory :attendance do
    full_name              {"水野"}
    email                 {"kkk@gmail.com"}
    password              {"kkk000"}
    password_confirmation {password}
    full_part             {1}
    affiliation_id        {3}

  end
end
