require 'articles_tag'

class Tag < ApplicationRecord
  has_many :articles_tag
  has_many :articles, through: :articles_tag

  validates :name, length: {maximum: 64}

  before_save do |tag|
    tag.css.downcase!
    tag.name.downcase!
  end
end
