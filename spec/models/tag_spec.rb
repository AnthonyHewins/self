require 'rails_helper'

RSpec.describe Tag, type: :model do
  it {should have_many :articles_tag}
  it {should have_many(:articles).through :articles_tag}

  %i[name css].each do |sym|
    it {should validate_presence_of(sym)}
  end

  it {should validate_length_of(:css).is_at_most(Tag::CSS_MAX)
              .is_at_least(Tag::CSS_MIN)}

  it {should validate_length_of(:name).is_at_most(Tag::NAME_MAX)
              .is_at_least(Tag::NAME_MIN)}
  it {should validate_uniqueness_of(:name).case_insensitive}

  before :each do
    @obj = create :tag
  end

  context 'before_save' do
    %i[css name].each do |attr|
      it "downcases #{attr}" do
        @obj.update attr => "UPCASE"
        expect(@obj.send attr).to eq "upcase"
      end
    end
  end
end
