class Comment < ApplicationRecord
  belongs_to :article

  validates :text, length: {in: 0..512}

  validates :user_id, presence: true
end
