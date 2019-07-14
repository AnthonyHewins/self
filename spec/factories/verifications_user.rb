require 'ffaker'

FactoryBot.define do
  factory :verifications_user do
    user
    tag
  end
end
