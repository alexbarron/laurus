FactoryBot.define do
  factory :parameter do
    name { "surname" }
    data_type { "string" }
    description { "A brilliant parameter!" }
    location { 0 }
  end
end
