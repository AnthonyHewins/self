require 'articles_tag'
require 'katex_parser'
require 'concerns/articles_validation'

class Article < PermissionModel
  include ActionView::Helpers::SanitizeHelper
  include ArticlesValidation

  alias_method :owner, :author

  before_save KatexParser.new(html: %i[body], no_html: %i[tldr title])

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
