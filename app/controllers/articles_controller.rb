require 'concerns/permission'

class ArticlesController < ApplicationController
  include Permission

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
      flash.now[:red] = @article.errors
      render :new
    end
  end

  def update
    if @article.update(article_params)
      redirect_to @article, flash: {green: 'Article was successfully updated.'}
    else
      flash.now[:red] = @article.errors
      render :edit
    end
  end

  def destroy
    if @article.destroy
      redirect_to articles_path, flash: {info: "Article successfully deleted."}
    else
      flash.now[:red] = @article.errors
      redirect_to @article
    end
  end
  
  private
  def find_articles
    Article.search(
      params[:q],
      tags: find_tags(params[:tags]),
      author: find_author(params[:author])
    ).with_attached_tldr_image
      .includes(:tags, :author)
      .order(updated_at: :desc)
  end

  def find_tags(tags)
    tags.blank? ? [] : Tag.find(tags.split(','))
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
    hash.merge tags: find_tags(params[:tags])
  end
end
