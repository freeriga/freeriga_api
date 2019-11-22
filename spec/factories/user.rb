# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    nickname { Faker::Name.last_name }
    email { Faker::Internet.email }
    association :location
    password { 'test_password' }
  end
end
