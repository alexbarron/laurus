FactoryBot.define do
    factory :user do
        name { "John Doe" }
        email { "john@example.it" }
        password { "password" }
        password_confirmation { "password" }
        platform_admin { false }
    end
end