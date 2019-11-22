# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    association :location
    association :user_location, factory: :location
    username { Faker::Sports::Football.player  }
    status { [0, 1, 2].sample }
    colour { Faker::Color.hex_color }
    I18n.available_locales.each do |locale|
      sequence(:"summary_#{locale}") do |n|
        Faker::TvShows::Community.quotes
      end
    end
    trait :with_user do
      association :user
    end
  end
end