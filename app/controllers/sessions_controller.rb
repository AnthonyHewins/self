class SessionsController < ApplicationController
  LOGIN_PROMPT = "Logged in successfully."
  EMAIL_NOT_CONFIRMED_PROMPT = "Email not yet confirmed. Please confirm your email to login."
  INCORRECT_COMBINATION_PROMPT = "Incorrect email/password combination."
  
  def new
  end

  def create
    user = find_user_by_params
    if user
      if user.email_confirmed?
        login user
      else
        invalid_login :warning, EMAIL_NOT_CONFIRMED_PROMPT
      end
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
  def find_user_by_params
    raise ActiveRecord::RecordNotFound if params[:email].nil?
    User.authenticate(params[:email].downcase, params[:password])
  end

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
