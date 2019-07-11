class SemanticUiIcon < ApplicationRecord
  has_many :tags

  ICON_MAX = 100
  
  validates :icon, length: {maximum: ICON_MAX}

  before_save do |semantic_ui_icon|
    semantic_ui_icon.icon&.downcase!
  end
end
