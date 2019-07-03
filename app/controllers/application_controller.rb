require 'concerns/permission'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  # Raise the exception if we're testing to validate a full interrupt occurs
  unless Rails.env.test?
    rescue_from Permission::AccessDenied do
      render file: "public/403", status: :forbidden
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
