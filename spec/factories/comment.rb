# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    association :item, factory: [:task, :quarter, :location].sample
    username { Faker::Company.name }
    association :location
    colour { Faker::Color.hex_color }
    sequence(:"body_#{['en', 'lv', 'ru'].sample}") do |n|
      Faker::Movies::Ghostbusters.quote
    end
  end
end