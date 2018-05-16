require 'ffaker'

FactoryBot.define do
  factory :tag do
    name { FFaker::BaconIpsum.characters rand(64) }
    css { FFaker::BaconIpsum.characters rand(64) }
  end
end
