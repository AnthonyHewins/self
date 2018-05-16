require 'ffaker'

FactoryBot.define do
  factory :article do

    title { FFaker::BaconIpsum.characters(
      rand(Article::TITLE_MAX - Article::TITLE_MIN) + Article::TITLE_MIN)
    }
    
    tldr  { FFaker::BaconIpsum.characters(
      rand(Article::TLDR_MAX)
    )}

    body  { FFaker::BaconIpsum.characters(
      rand(100) + Article::BODY_MIN
    )}
    
    association :author, factory: :user
  end
end
