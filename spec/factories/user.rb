require 'ffaker'
require 'date'

FactoryBot.define do
  factory :user do
    password {
      "a1!234" + FFaker::BaconIpsum.characters(rand(UserValidator::PW_MAX - UserValidator::PW_MIN))
    }

    handle {
      FFaker::BaconIpsum.characters(
        UserValidator::HANDLE_MIN + rand(UserValidator::HANDLE_MAX - UserValidator::HANDLE_MIN)
      )
    }

    created_at { DateTime.now }
  end
end
