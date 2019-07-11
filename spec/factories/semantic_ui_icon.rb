require 'ffaker'
require 'semantic_ui_icon'

FactoryBot.define do
  factory :semantic_ui_icon do
    icon { FFaker::Lorem.word }
  end
end
