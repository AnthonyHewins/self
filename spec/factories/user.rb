require 'ffaker'
require 'date'

pw_max = 512
pw_min = 6

handle_max = 64
handle_min = 1

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { FFaker::BaconIpsum.characters(pw_min + rand(pw_max - pw_min)) }
    handle { FFaker::BaconIpsum.characters(handle_min + rand(handle_max - handle_min)) }
    created_at { DateTime.now }
    email_confirmed { true }
    confirm_token { nil }

    after(:create) do |user|
      # We want to give the server the impression that the user has already been
      # created in the system; that means no confirmation token, since on create,
      # we give the user a confirmation token (which would be every call to create(:user))
      user.update confirm_token: nil
    end
  end
end
