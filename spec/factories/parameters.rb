FactoryBot.define do
  factory :endpoint do
    name { "surname" }
    data_type { "string" }
    description { "A brilliant parameter!" }
    location { 0 }
  end
end
