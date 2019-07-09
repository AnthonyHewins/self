require 'articles_tag'

class Tag < ApplicationRecord
  has_many :articles_tag
  has_many :articles, through: :articles_tag

  NAME_MIN = 3
  NAME_MAX = 64

  CSS_MIN = NAME_MIN
  CSS_MAX = NAME_MAX

  validates :css,
            presence: true,
            length: {minimum: CSS_MIN,
                     maximum: CSS_MAX}

  validates :name,
            presence: true,
            uniqueness: {case_sensitive: false},
            length: {minimum: NAME_MIN,
                     maximum: NAME_MAX}

  before_save do |tag|
    tag.css.downcase!
    tag.name.downcase!
  end
end
