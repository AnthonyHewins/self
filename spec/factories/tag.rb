require 'ffaker'
require 'tag'

FactoryBot.define do
  factory :tag do
    name {
      FFaker::BaconIpsum.characters(
        Tag::NAME_MIN + rand(Tag::NAME_MAX - Tag::NAME_MIN)
      )
    }

    css {
      FFaker::BaconIpsum.characters(
        Tag::CSS_MIN + rand(Tag::CSS_MAX - Tag::CSS_MIN)
      )
    }
  end
end
