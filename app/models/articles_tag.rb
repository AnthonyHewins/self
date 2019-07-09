require 'article'
require 'tag'

class ArticlesTag < ApplicationRecord
  belongs_to :article
  belongs_to :tag

  validates :tag, uniqueness: {scope: %i[article]}

  MAX_TAGS = 5
  
  validate do |record|
    count = ArticlesTag.where(article_id: record.article_id).count
    record.errors[:article] << "has the max amount of tags" if count > MAX_TAGS
  end
end
