class Project < ApplicationRecord
  URL_REGEX = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix
  FILENAME_REGEX = /\A[A-z0-9\s_-]+\.[A-z]{1,6}\z/

  validates :name, length: {in: 3..100},
                   uniqueness: true,
                   blank: false

  validates :description, length: {in: 0..1000},
                          blank: false

  validates :url, blank: false,
                  uniqueness: true,
                  format: {with:  URL_REGEX, message: "needs to be a valid URL format"}

  validates :image, format: {with: FILENAME_REGEX, message: "filename invalid"},
                    blank: false
end
