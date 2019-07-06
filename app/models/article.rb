require 'articles_tag'
require 'article_validator'
require 'concerns/katex_parser'

class Article < PermissionModel
  include ActiveModel::Validations
  include ActionView::Helpers::SanitizeHelper

  has_many :articles_tag
  has_many :tags, through: :articles_tag
  belongs_to :author, class_name: "User", foreign_key: :author_id, optional: true
  has_one_attached :tldr_image

  validates :title, presence: true, length: {minimum: ArticleValidator::TITLE_MIN,
                                             maximum: ArticleValidator::TITLE_MAX}

  validates :tldr, length: {maximum: ArticleValidator::TLDR_MAX}

  validates :body, presence: true, length: {minimum: ArticleValidator::BODY_MIN}

  validates :views, numericality: {only_integer: true, greater_than_or_equal_to: 0}

  validates_with ArticleValidator

  before_save KatexParser.instance

  alias_method :owner, :author

  def get_title
    return title_katex.html_safe unless title_katex.blank?
    strip_tags(title)
  end
  
  def get_tldr
    return tldr_katex.html_safe unless tldr_katex.blank?
    strip_tags(tldr)
  end
  
  def get_body
    return body_katex.html_safe unless body_katex.nil?
    body&.html_safe
  end
  
  def self.search(q=nil, tags: nil, author: nil)
    query = search_by_tags tags
    query = search_by_author(query, author)
    q.blank? ? query : omnisearch(query, q)
  end

  class << self
    private
    def search_by_tags(tags, query=nil)
      case tags
      when Array, ActiveRecord::Relation
        query = join
        tags.each {|tag| query = search_by_tags(tag, query)}
        query
      when Integer, Tag
        join.where tags: {id: tags}
      when NilClass
        Article.left_outer_joins(:author)
      else
        raise TypeError
      end
    end

    def join
      Article.includes(:tags).left_outer_joins(:author)
    end
    
    def omnisearch(query_chain, q)
      query_chain.where "title ilike :q or tldr ilike :q or body ilike :q", q: "%#{q}%"
    end

    def search_by_author(query_chain, author)
      case author
      when User
        query_chain.where author: author
      when String
        author.empty? ? query_chain : query_chain.where('users.handle = :author', author: author)
      when NilClass
        query_chain
      else
        raise TypeError
      end
    end
  end
end
