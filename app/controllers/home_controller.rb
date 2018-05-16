class HomeController < ApplicationController

  skip_before_action :authenticate_user!

  def index
  end

  def register
  end

  def login
  end
end
