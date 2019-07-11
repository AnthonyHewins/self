class Tag < ApplicationRecord
  has_many :articles_tag
  has_many :articles, through: :articles_tag
  belongs_to :semantic_ui_icon

  NAME_MIN = 3
  NAME_MAX = 64

  COLOR_MIN = 3
  COLOR_MAX = 6
  COLOR_REGEX = /\A([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/i

  validates :color,
            format: {with: COLOR_REGEX},
            length: {minimum: COLOR_MIN, maximum: COLOR_MAX}

  validates :name,
            presence: true,
            uniqueness: {case_sensitive: false},
            length: {minimum: NAME_MIN, maximum: NAME_MAX}

  alias_method :icon, :semantic_ui_icon

  before_validation do |tag|
    tag.color.sub!('#', '')
  end

  before_save do |tag|
    tag.name.downcase!
    tag.color&.downcase!
  end
end
