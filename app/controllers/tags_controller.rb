require 'concerns/permission'

class TagsController < ApplicationController
  include Concerns::Permission

  before_action :admin_only, only: %i[new create edit]

  def new
  end

  def edit
  end

  def create
  end

  def index
  end
end
