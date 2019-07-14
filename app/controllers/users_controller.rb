require 'concerns/permission'
require 'concerns/error_actions'
require 'concerns/taggable'

class UsersController < ApplicationController
  include Concerns::Permission
  include Concerns::ErrorActions
  include Concerns::Taggable

  before_action :authorize, only: %i[change_password update_password update destroy edit]
  before_action :mod_as_admin, only: %i[verify]

  UPDATE = 'User was successfully updated.'.freeze
  DELETE = "User successfully deleted.".freeze
  PW_CHANGED = "Successfully changed password.".freeze
  PW_MISMATCH = "New password and confirm password do not match".freeze
  ORIGINAL_PW_INCORRECT = "Current password was incorrect. Enter current password to change it to new password.".freeze

  def index
    @users = User.all
  end

  def show
    @user = User.includes(:articles).find(params[:id])
  end
 
  def edit
  end

  def verify
    if @user.update tags: find_tags
      redirect_to @user, flash: {green: "Verified #{@user.handle}."}
    else
      error @user.errors, :show
    end
  end
  
  def update
    if current_user.update(user_params)
      redirect_to current_user, flash: {green: UPDATE}
    else
      error current_user.errors, :edit
    end
  end

  def destroy
    if current_user.destroy
      redirect_to users_path, flash: {info: DELETE}
      reset_session
    else
      flash.now[:red] = current_user.errors
      redirect_to current_user
    end
  end

  def update_password
    if params[:new] == params[:confirm]
      change_password current_user.authenticate(params[:current])
    else
      error PW_MISMATCH, 'change_password'
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:handle, :profile_picture)
  end

  def change_password(user)
    if user
      try_change_password user, params[:new]
    else
      error ORIGINAL_PW_INCORRECT, 'change_password'
    end
  end

  def try_change_password(user, new_pw)
    if user.update(password: new_pw)
      redirect_to user, flash: {info: PW_CHANGED}
    else
      error user.errors, 'change_password'
    end
  end
end
