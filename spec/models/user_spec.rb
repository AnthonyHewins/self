require 'rails_helper'
require_relative '../custom_matchers/validate_with'

RSpec.describe User, type: :model do
  it {should have_secure_password}
  it {should have_many(:articles).dependent(:nullify)}

  it {should validate_with(UserValidator)}
  
  context "constants" do
    [[:PW_MIN, 6], [:PW_MAX, 72], [:HANDLE_MIN, 1], [:HANDLE_MAX, 64]].each do |name, val|
      it "#{name} equals #{val}" do
        expect(UserValidator.const_get name).to eq val
      end
    end
  end

  context ':password' do
    subject {build :user, password: nil}
    it {should validate_presence_of :password}
    it {should validate_length_of(:password)
                .is_at_least(UserValidator::PW_MIN)
                .is_at_most(UserValidator::PW_MAX)}
    it {should_not allow_value('a' * 6).for :password} # Missing number/special char
    it {should_not allow_value('1' * 6).for :password} # Missing letter
    it {should_not allow_value('!' * 6).for :password} # Missing letter

    it 'shouldnt validate the password when it isnt being changed' do
      user = create :user
      expect{user.update handle: "hi12"}.to_not raise_error
    end

    it "password should allow anything in #{UserValidator::PW_SPECIAL_CHARS}" do
      UserValidator::PW_SPECIAL_CHARS.each_char do |i|
        should allow_value("a#{i}" * 3).for :password
      end
    end
  end

  context 'before_save' do
    it 'strips whitespace from :handle' do
      expect(create(:user, handle: "   a    ").handle).to eq 'a'
    end
  end

  context ':handle' do
    it {should validate_length_of(:handle).is_at_least(1).is_at_most(64)}
    it {should validate_presence_of(:handle)}
    it {should_not allow_value("Anonymous").for :handle}

    it 'is unique, with nil not being a legitimate use case' do
      obj = create(:user)
      expect(build(:user, handle: obj.handle)).to be_invalid
    end
  end

  it '#owner returns self' do
    user = create :user
    expect(user.owner).to be user
  end
  
  context '#has_permission?(*models, &block)' do
    before :each do
      @random_dudes_articles = [create(:article, author: create(:user))] * 2
    end

    it 'throws NoMethodError unless each model responds_to? :owner' do
      expect{create(:user).has_permission? ""}.to raise_error NoMethodError
    end
    
    context 'as an admin' do
      before :each do
        @admin = create :user, admin: true
      end

      it 'allows accessing anyones stuff (without a block_given)' do
        expect(@admin.has_permission? *@random_dudes_articles).to be true
      end

      it 'allows accessing anyones stuff if the block_given returns true' do
        expect(@admin.has_permission?(*@random_dudes_articles) {true}).to be true
      end
      
      it 'doesnt allow accessing anyones stuff if the block_given returns false' do
        expect(@admin.has_permission?(*@random_dudes_articles) {false}).to be false
      end
    end

    context 'as a regular user' do
      before :each do
        @user = create :user
      end

      it 'doesnt allow you access to anyone elses stuff' do
        expect(@user.has_permission? *@random_dudes_articles).to be false
      end

      context 'if youre using your stuff' do
        before :each do
          @your_stuff = [create(:article, author: @user)] * 2
        end
        
        it 'allows you to access it' do
          expect(@user.has_permission? *@your_stuff).to be true
        end

        it 'doesnt allow you to access it if the block_given is false' do
          expect(@user.has_permission?(*@your_stuff) {false}).to be false
        end

        it 'allows you to access it if the block_given is true' do
          expect(@user.has_permission?(*@your_stuff) {true}).to be true
        end
      end
    end
  end
end
