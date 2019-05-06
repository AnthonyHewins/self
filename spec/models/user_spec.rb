require 'rails_helper'

RSpec.describe User, type: :model do

  it {should have_secure_password}
  it {should have_many(:articles).dependent(:nullify)}

  context ':password' do
    subject {build :user, password: nil}
    it {should validate_presence_of :password}
    it {should validate_confirmation_of :password}
    it {should validate_length_of(:password).is_at_least(6).is_at_most(72)}
    it {should_not allow_value('a' * 6).for :password} # Missing number/special char
    it {should_not allow_value('1' * 6).for :password} # Missing letter
    it {should_not allow_value('!' * 6).for :password} # Missing letter
    
    it 'shouldnt validate the password when it isnt being changed' do
      user = create :user
      expect{user.update handle: "hi12"}.to_not raise_error
    end
    
    it 'password should allow all special chars' do
      '!@\#$%^&*()<>'.each_char {|i| should allow_value("a#{i}" * 3).for :password}
    end
  end

  context 'before_save' do
    it 'downcases :handle' do
      user = create :user, handle: "AAA"
      expect(user.handle).to eq 'aaa'
    end
  end
  
  context ':handle' do
    it {should validate_length_of(:handle).is_at_least(1).is_at_most(64)}
    it {should_not validate_presence_of(:handle)}
    it {should validate_uniqueness_of(:handle).case_insensitive}
    it {should_not allow_value("Anonymous").for :handle}
  end
  
  it '#owner returns self' do
    user = create :user
    expect(user.owner).to eq user
  end
  
  context '#has_permission?' do
    before :each do
      @random_dudes_articles = [create(:article, author: create(:user))] * 2
    end

    it 'throws an error if all the models supplied do not subclass PermissionModel' do
      expect{create(:user).has_permission? "string doesn't inherit PermissionModel"}.to raise_error TypeError
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
