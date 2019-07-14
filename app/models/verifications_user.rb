class VerificationsUser < ApplicationRecord
  belongs_to :user
  belongs_to :tag

  validates :tag, uniqueness: {scope: %i[user]}
end
