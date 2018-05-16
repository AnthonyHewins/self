require Rails.root.join 'lib/assets/permission'

class ArticlesController < ApplicationController
  include Permission
  before_action :set_and_authorize, only: [:edit, :update, :destroy]
  before_action :set_article, only: :show

  def index
    @articles = Article.search params[:q], tags: find_tags, author: find_author
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new article_params.merge(author: current_user)

    respond_to do |format|
      if @article.save
        format.html {redirect_to @article, notice: 'Article was successfully created.'}
        format.json {render :show, status: :created, location: @article}
      else
        flash.now[:red] = @article.errors
        format.html {render :new}
        format.json {render json: @article.errors, status: :unprocessable_entity}
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, flash: {green: 'Article was successfully updated.'}}
        format.json { render :show, status: :ok, location: @article }
      else
        flash.now[:red] = @article.errors
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def find_tags
    return nil if params[:tags].blank?
    params[:tags].split(',').map {|i| klass.find i}
  end
  
  def find_author
    return nil if params[:author].blank?
    User.find params[:author]
  end
  
  def set_article
    @article = Article.find params[:id]
  end

  def article_params
    hash = params.require(:article).permit(:title, :body, :tldr, :tldr_image)
    return hash unless params.key? :tags
    hash[:tags] = params[:tags].split(', ').map {|id| Tag.find id}
    hash
  end
end
