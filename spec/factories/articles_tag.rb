require 'ffaker'

FactoryBot.define do
  factory :articles_tag do
    article
    tag
  end
end
