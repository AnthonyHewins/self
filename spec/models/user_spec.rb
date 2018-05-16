require 'rails_helper'

RSpec.describe User, type: :model do
  #================================================
  # Validations
  #================================================
  context 'password' do
    it {should validate_presence_of :password}
    it {should validate_confirmation_of :password}
    it {should validate_length_of(:password).is_at_least(6).is_at_most(512)}
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

    it 'should be nil after saving' do
      user = create :user
      user.password = "a!" * 3
      user.save!
      expect(user.password).to be_nil
    end
  end

  context 'confirmation_token' do
    it {should validate_absence_of(:confirm_token).on(:update)}
  end

  context 'email' do
    it {should validate_length_of(:email).is_at_least(5).is_at_most(512)}
    it {should validate_uniqueness_of(:email).case_insensitive}
    it {should allow_value(FFaker::Internet.email).for :email}
  end

  context 'handle' do
    it {should validate_length_of(:handle).is_at_least(1).is_at_most(64)}
    it {should validate_uniqueness_of(:handle).case_insensitive}
    it {should_not validate_presence_of(:handle)}
    it {should_not allow_value("Anonymous").for :handle}
    it {should_not allow_value("anonymous").for :handle}
  end
  
  #================================================
  # Static methods
  #================================================  
  context '#authenticate (static)' do
    before :each do
      @pw = "a!" * 3
      @user = create(:user, password: @pw)
    end
    
    it 'works with valid credentials' do
      expect(User.authenticate(@user.email, @pw)).to eq @user
    end

    it 'returns nil with a bad email' do
      expect(User.authenticate("asdasd", @pw)).to be_nil
    end

    it 'returns nil with a bad password' do
      expect(User.authenticate(@user.email, "badpw")).to be_nil
    end
  end

  context '#register_email' do
    before :each do
      @user = create :user, email_confirmed: false
    end

    it 'returns false if user.registration_attempt_time is nil' do
      expect(@user.register_email).to be false
    end

    context 'returns' do
      before :each do
        now = DateTime.now
        @user.update registration_attempt_time: now
      end
      
      it 'false if youre 15 minutes late to confirm the token' do
        over_15_minutes_ago = @user.registration_attempt_time + ((60 * 15) + 1)
        expect(@user.register_email over_15_minutes_ago).to be false
      end

      it 'true if you confirm the token within 15 minutes' do
        less_than_15_min_ago = @user.registration_attempt_time + ((60 * 15) - 1)
        expect(@user.register_email less_than_15_min_ago).to be true
      end
    end

    context 'after confirmation' do
      before :each do
        @user.update(registration_attempt_time: DateTime.now)
        @user.register_email
      end

      it {expect(@user.confirm_token).to be_nil}
      it {expect(@user.registration_attempt_time).to be_nil}
      it {expect(@user.email_confirmed).to be true}
    end
  end

  context '#owner' do
    it 'returns self to keep #has_permission? reflexive' do
      user = create :user
      expect(user.owner).to eq user
    end
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
