class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  IS_SUCCESS = "is-success"
  IS_PRIMARY = "is-primary"
  IS_LINK = "is-link"
  IS_INFO = "is-info"
  IS_WARNING = "is-warning"
  IS_DANGER = "is-danger"

  def toggle_flash(style, header, msg)
    # Make sure that the style (key) being used is actually supported
    if !([IS_DANGER, IS_SUCCESS, IS_PRIMARY, IS_LINK, IS_WARNING, IS_INFO].include? style)
      raise ArgumentError.new("'key' must be chosen from a predefined list of constants in ApplicationController")
    end


    flash["header"] = header
    flash["style"] = style
    flash["message"] = msg
  end
end
