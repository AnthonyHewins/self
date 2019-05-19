require 'ffaker'
require 'date'

FactoryBot.define do
  factory :user do
    password {
      "a1!234" + FFaker::BaconIpsum.characters(rand(User::PW_MAX - User::PW_MIN))
    }

    handle {
      FFaker::BaconIpsum.characters(
        User::HANDLE_MIN + rand(User::HANDLE_MAX - User::HANDLE_MIN)
      )
    }

    created_at { DateTime.now }
  end
end
