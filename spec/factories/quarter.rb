# frozen_string_literal: true

FactoryBot.define do
  factory :quarter do
    name { Faker::Company.name }
    address {  Faker::Address.street_address }
  end
end