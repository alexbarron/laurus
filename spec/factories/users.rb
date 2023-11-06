FactoryBot.define do
  factory :user do
    name { 'John Doe' }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    platform_admin { false }
  end
end
