FactoryBot.define do
  factory :user do
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}"}
    sequence(:email) {|n|"test_user#{n}@test.com"}
    options_data { {} }
  end
end
