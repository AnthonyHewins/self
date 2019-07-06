require 'rails_helper'
require_relative '../../spec_helper_modules/login'

RSpec.configure do |config|
  config.include Login
end

RSpec.describe "Deleting account", type: :feature do
  context 'when not a logged in user' do
    it 'wont show you the delete account link' do
      expect(page.body).to_not include "Delete account"
    end
  end

  context 'when logged in' do
    before :each do
      @user = login
    end
    
    context 'but not the owner of the current profile' do
      before :each do
        @other_user = create :user
        visit user_path @other_user
      end
      
      it 'doesnt show you the delete link' do
        expect(page.body).to_not include "Delete account"
      end
    end

    context 'as the user that is being viewed' do
      before :each do
        visit user_path @user
      end

      it 'shows the delete link' do
        expect(page.body).to include "Delete account"
      end

      it 'deletes the account when clicked on' do
        click_on "Delete account"
        expect{User.find @user.id}.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
