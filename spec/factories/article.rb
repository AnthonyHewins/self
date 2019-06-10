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

    after :build do |article|
      article.tldr_image.attach(
        io: Tempfile.new,
        filename: FFaker::Lorem.word,
        content_type: 'image/jpeg'
      )
    end
  end
end
