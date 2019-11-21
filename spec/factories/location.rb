# frozen_string_literal: true

FactoryBot.define do
  factory :location do
    association :quarter
    name { Faker::Company.name }
    nickname { Faker::Company.name }
  end
end