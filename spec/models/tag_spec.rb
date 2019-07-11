require 'rails_helper'

require_relative '../custom_matchers/define_constant'

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
  %w(#000 #000000 asdass).each do |val|
    it {should_not allow_value(val).for :color}
  end

  it {should define_constant :NAME_MIN, 3}
  it {should define_constant :NAME_MAX, 64}

  it {should define_constant :COLOR_MIN, 3}
  it {should define_constant :COLOR_MAX, 6}
  it {should define_constant :COLOR_REGEX, /\A([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/i}

  it {should have_alias_method :icon, :semantic_ui_icon}

  before :each do
    @obj = create :tag
  end

  context 'before_save' do
    %i[color name].each do |attr|
      it "downcases #{attr}" do
        @obj.update attr => @obj.send(attr).upcase
        expect(@obj.send attr).to eq @obj.send(attr).downcase
      end
    end
  end
end
