require Rails.root.join 'lib/assets/permission'

class ArticlesController < ApplicationController
  include Permission
  before_action :set_and_authorize, only: %i(edit update destroy)
  before_action :authorize, only: %i(new create)
  before_action :set_article, only: :show

  def index
    @articles = Article.search params[:q], tags: find_tags, author: find_author
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new article_params

    if @article.save
      redirect_to @article, green: 'Article was successfully created.'
    else
      flash.now[:red] = @article.errors
      render :new
    end
  end

  def update
    article_params.delete(:author) unless @article.author.nil?
    
    if @article.update(article_params)
      redirect_to @article, flash: {green: 'Article was successfully updated.'}
    else
      flash.now[:red] = @article.errors
      render :edit
    end
  end

  private
  def find_tags
    return nil if params[:tags].blank?
    params[:tags].split(',').map {|i| Tag.find i}
  end

  def find_author
    return nil if params[:author].blank?
    User.find params[:author]
  end

  def set_article
    @article = Article.find params[:id]
  end

  def article_params
    hash = params.require(:article).permit :title, :body, :tldr, :tldr_image, :anonymous
    hash[:author] = hash.delete(:anonymous) == "1" ? nil : current_user
    return hash unless params.key? :tags
    hash[:tags] = params[:tags].split(', ').map {|id| Tag.find id}
    hash
  end
end
