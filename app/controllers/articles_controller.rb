require 'concerns/permission'
require 'concerns/error_actions'

class ArticlesController < ApplicationController
  include Concerns::Permission
  include Concerns::ErrorActions
  include Concerns::Taggable

  before_action :set_and_authorize, only: %i[edit update destroy]
  before_action :authorize, only: %i[new create]
  before_action :set_article, only: :show

  def index
    @articles = find_articles.paginate(page: params[:page], per_page: 10)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new article_params

    if @article.save
      redirect_to @article, flash: {green: 'Article was successfully created.'}
    else
      error @article.errors, :new
    end
  end

  def show
    @article.update views: @article.views.succ
  end

  def update
    if @article.update(article_params)
      redirect_to @article, flash: {green: 'Article was successfully updated.'}
    else
      error @article.errors, :edit
    end
  end

  def destroy
    if @article.destroy
      redirect_to articles_path, flash: {info: "Article successfully deleted."}
    else
      error @article.errors, @article
    end
  end
  
  private
  def find_articles
    Article.search(
      params[:q],
      tags: find_tags,
      author: find_author(params[:users])
    ).with_attached_tldr_image
      .includes(:tags, :author)
      .order(updated_at: :desc)
  end

  def find_author(author)
    author.blank? ? nil : User.find(author)
  end

  def set_article
    @article = Article.find params[:id]
  end

  def article_params
    hash = params.require(:article).permit :title, :body, :tldr, :tldr_image, :anonymous
    hash[:author] = hash.delete(:anonymous) == '1' ? nil : current_user
    hash.merge tags: find_tags
  end
end
