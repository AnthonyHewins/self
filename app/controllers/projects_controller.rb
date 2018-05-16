require 'pp'

class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.all
  end

  def show
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    # Since we're dealing with images we need to go through additional checks
    # Create projects so we can add errors if anything's wrong with the image
    # If not continue doing everything normally

    # TODO: handle this error more gracefully and add it to validation errors
    image_object = params[:project][:image]
    if !image_object.respond_to?("original_filename")
      toggle_flash(IS_DANGER, "Image error","Must upload a file with a valid filename")
      redirect_to new_project_path
      return
    end

    @project = Project.new(
        name: params[:project][:name],
        description: params[:project][:description],
        url: params[:project][:url],
        image: image_object.original_filename
    )

    # Try to save to the DB first, if there are errors with any of these
    # we need to not process the image upload
    respond_to do |format|
      if @project.save
        format.html {redirect_to @project}
        format.json {render :show, status: :created, location: @project}

        uploaded_io = params[:project][:image]
        File.open(Rails.root.join('app', 'assets', 'images', uploaded_io.original_filename), 'wb') do |file|
          file.write(uploaded_io.read)
        end

        toggle_flash(IS_SUCCESS, "Success!", "Project was successfully created.")
      else
        format.html {render :new}
        format.json {render json: @project.errors, status: :unprocessable_entity}
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html {redirect_to @project}
        format.json {render :show, status: :ok, location: @project}
        toggle_flash(IS_SUCCESS, "Success!", "Project was successfully updated.")
      else
        format.html {render :edit}
        format.json {render json: @project.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html {redirect_to projects_url}
      format.json {head :no_content}
      toggle_flash(IS_SUCCESS, "Success!", "Project was successfully destroyed.")
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :url, :image)
  end
end
