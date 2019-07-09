require 'article'
require 'tag'

class ArticlesTag < ApplicationRecord
  belongs_to :article
  belongs_to :tag

  validates :tag, uniqueness: {scope: %i[article]}
end
