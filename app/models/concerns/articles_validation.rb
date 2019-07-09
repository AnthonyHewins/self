require 'active_support/concern'
require 'article_validator'

module ArticlesValidation
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Validations

    has_many :articles_tag
    has_many :tags, through: :articles_tag
    has_one_attached :tldr_image

    belongs_to :author, class_name: "User", foreign_key: :author_id, optional: true

    validates :title,
              presence: true,
              length: {minimum: ArticleValidator::TITLE_MIN,
                       maximum: ArticleValidator::TITLE_MAX}

    validates :tldr, length: {maximum: ArticleValidator::TLDR_MAX}

    validates :body, presence: true, length: {minimum: ArticleValidator::BODY_MIN}

    validates :views, numericality: {only_integer: true, greater_than_or_equal_to: 0}

    validates_with ArticleValidator
  end
end
