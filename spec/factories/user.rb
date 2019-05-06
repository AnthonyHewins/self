require 'ffaker'
require 'date'

FactoryBot.define do
  factory :user do
    password {
      "a1!234" + FFaker::BaconIpsum.characters(
         + rand(User::PW_MAX_LENGTH - User::PW_MIN_LENGTH)
      )
    }
    
    handle {
      FFaker::BaconIpsum.characters(
        User::HANDLE_MIN_LENGTH + rand(User::HANDLE_MAX_LENGTH - User::HANDLE_MIN_LENGTH)
      )
    }

    created_at { DateTime.now }
  end
end
