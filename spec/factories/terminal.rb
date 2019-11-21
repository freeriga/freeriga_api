# frozen_string_literal: true

FactoryBot.define do
  factory :terminal do
    association :location
    email { Faker::Internet.email }
    password { 'test_password' }
    name { Faker::Internet.username }
  end
end