require 'rails_helper'
require_relative '../../spec_helper_modules/login'

RSpec.configure do |config|
  config.include Login
end

RSpec.describe "Change password", type: :feature do
  before :all do
    @pw = "a!!!!!"
  end

  before :each do
    @user = create :user, password: @pw
    login @user, @pw
    visit change_password_users_path
  end

  context 'when current password is incorrect' do
    before :each do
      fill_in "current", with: @pw + 'a'
      click_on "Submit"
    end
    
    it 'returns an error message about it not matching' do
      expect(find('#flash').text).to include UsersController::ORIGINAL_PW_INCORRECT
    end

    it 'still uses the old password' do
      expect(@user.authenticate(@pw)).to eq @user
    end
  end

  context 'when current password is correct' do
    before :each do
      @new_pw = "a!2345"
      
      fill_in "current", with: @pw
      fill_in "new", with: @new_pw
    end

    context 'but new password doesnt match confirmation password' do
      before :each do
        fill_in 'confirm', with: @new_pw + '1'
        click_on 'Submit'
      end

      it 'returns an error message about it not matching' do
        expect(find('#flash').text).to include UsersController::PW_MISMATCH
      end

      it 'still uses the old password' do
        expect(@user.authenticate(@pw)).to eq @user
      end
    end

    context 'and new password matches confirmation password' do
      before :each do
        fill_in 'confirm', with: @new_pw
        click_on 'Submit'
      end

      it 'successfully changes the password' do
        expect(find('#flash').text).to include UsersController::PW_CHANGED
      end

      it 'redirects to your profile' do
        expect(page).to have_current_path user_path(@user)
      end
      
      it 'uses the new password' do
        expect(@user.reload.authenticate(@new_pw)).to eq @user
      end
    end
  end
end
