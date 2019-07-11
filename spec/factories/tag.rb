require 'ffaker'
require 'tag'

FactoryBot.define do
  factory :tag do
    name {
      FFaker::BaconIpsum.characters(
        Tag::NAME_MIN + rand(Tag::NAME_MAX - Tag::NAME_MIN)
      )
    }

    color { FFaker::Color.hex_code }

    semantic_ui_icon
  end
end
