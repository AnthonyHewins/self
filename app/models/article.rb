class Article < ApplicationRecord
  has_many :comments

  validates :description, length: {in: 0..16384}
end
