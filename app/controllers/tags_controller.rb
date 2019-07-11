require 'concerns/permission'
require 'concerns/error_actions'

class TagsController < ApplicationController
  include Concerns::Permission
  include Concerns::ErrorActions

  before_action :admin_only, except: :index
  before_action :set_tag, only: %i[edit update destroy]

  def index
    @tags = Tag.all
  end

  def edit
  end

  def create
    tag = Tag.new tag_params

    if tag.save
      redirect_to tags_path, flash: {green: 'Tag successfully created.'}
    else
      error tag.errors, :new
    end
  end

  def update
    if @tag.update tag_params
      redirect_to tags_path, flash: {green: 'Tag successfully updated.'}
    else
      error @tag.errors, :edit
    end
  end

  def destroy
    if @tag.destroy
      redirect_to tags_path, flash: {info: 'Tag successfully deleted.'}
    else
      error @tag.errors, :index
    end
  end

  private
  def set_tag
    @tag = Tag.find params[:id]
  end

  def tag_params
    params.require(:tag).permit :name, :color, :semantic_ui_icon_id
  end
end
