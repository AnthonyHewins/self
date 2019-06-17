class SessionsController < ApplicationController
  LOGIN_PROMPT = 'Logged in successfully.'.freeze
  INCORRECT_COMBINATION_PROMPT = 'Incorrect handle/password combination.'.freeze
  
  def new
  end

  def create
    user = User.find_by(handle: params[:handle])&.authenticate params[:password]
    if user
      login user
    else
      invalid_login :red, INCORRECT_COMBINATION_PROMPT
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = "Successfully logged out."
    redirect_to root_url
  end

  private
  def login(user)
    session[:user_id] = user.id
    flash[:info] = LOGIN_PROMPT
    redirect_to root_url
  end

  def invalid_login(flash_message_class, text)
    flash.now[flash_message_class] = text
    render 'new'
  end
end
