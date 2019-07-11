require 'rails_helper'

require_relative '../custom_matchers/define_constant'

RSpec.describe SemanticUiIcon, type: :model do
  it {should have_many :tags}

  it {should validate_length_of(:icon).is_at_most(SemanticUiIcon::ICON_MAX)}

  it {should define_constant :ICON_MAX, 100}
  
  before :each do
    @obj = create :semantic_ui_icon
  end

  context 'before_save' do
    it "downcases icon if not nil" do
      @obj.update icon: "UPCASE"
      expect(@obj.icon).to eq "upcase"
    end
  end
end
