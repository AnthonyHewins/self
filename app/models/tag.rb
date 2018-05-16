class Tag < ApplicationRecord
  validates :name,
            length: {maximum: 64}
  has_and_belongs_to_many :articles

  before_save do |tag|
    tag.css.downcase!
    tag.name.downcase!
  end
end
