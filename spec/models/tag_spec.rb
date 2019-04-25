require 'rails_helper'

RSpec.describe Tag, type: :model do
  it {should validate_length_of(:name).is_at_most(64)}
  it {should have_and_belong_to_many :articles}

  before :each do
    @obj = create :tag
  end
  
  context 'before_save' do
    [:css, :name].each do |attr|
      it "downcases #{attr}" do
        @obj.update attr => "UPCASE"
        expect(@obj.send attr).to eq "upcase"
      end
    end
  end
end