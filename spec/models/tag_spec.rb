require 'rails_helper'

require_relative '../custom_matchers/define_constant'
require_relative '../custom_matchers/have_alias_method'

RSpec.describe Tag, type: :model do
  it {should have_many :articles_tag}
  it {should have_many(:articles).through :articles_tag}

  it {should belong_to :semantic_ui_icon}

  it {should validate_presence_of(:name)}
  it {should validate_uniqueness_of(:name).case_insensitive}
  it {should validate_length_of(:name).is_at_most(Tag::NAME_MAX)
              .is_at_least(Tag::NAME_MIN)}

  it {should validate_length_of(:color).is_at_most(Tag::COLOR_MAX)
               .is_at_least(Tag::COLOR_MIN)}

  %w(#000 #000000 000 000000).each do |val|
    it {should allow_value(val).for :color}
  end
  

  it {should define_constant :NAME_MIN, 3}
  it {should define_constant :NAME_MAX, 64}

  it {should define_constant :COLOR_MIN, 3}
  it {should define_constant :COLOR_MAX, 7}
  it {should define_constant :COLOR_REGEX, /\A[#]{0,1}([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/i}

  it {should have_alias_method :icon, :semantic_ui_icon}

  before :each do
    @obj = create :tag
  end

  context 'before_save' do
    it "downcases name" do
      @obj.update name: @obj.name.upcase
      expect(@obj.name).to eq @obj.name.downcase
    end

    it 'downcases color and removes the # if it exists' do
      @obj.update color: "##{@obj.color.upcase}"
      expect(@obj.color).to eq @obj.color.downcase.sub('#', '')
    end
  end
end
