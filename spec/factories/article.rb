require 'ffaker'

FactoryBot.define do
  factory :article do

    views { rand(10000) }
    
    title { FFaker::BaconIpsum.characters(
      rand(ArticleValidator::TITLE_MAX - ArticleValidator::TITLE_MIN) + ArticleValidator::TITLE_MIN)
    }
    
    tldr  { FFaker::BaconIpsum.characters(
      rand(ArticleValidator::TLDR_MAX)
    )}

    body  { FFaker::BaconIpsum.characters(
      rand(100) + ArticleValidator::BODY_MIN
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
