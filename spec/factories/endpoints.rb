FactoryBot.define do
    factory :endpoint do
        path { "/v2/widgets" }
        http_method { "POST" } # aliased because method is reserved and factory fails with it
        description { "A brilliant endpoint!" }
    end
end