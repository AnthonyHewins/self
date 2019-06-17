require 'articles_tag'

class Article < PermissionModel
  TITLE_MIN = 10
  TITLE_MAX = 1000

  TLDR_MAX = 1500

  TLDR_IMAGE_MAX = 10_000_000
  
  TLDR_IMAGE_BAD_TYPE = 'is not the right content type (must be image)'
  
  BODY_MIN = 128

  TAGS_MAX = 5

  has_many :articles_tag
  has_many :tags, through: :articles_tag
  belongs_to :author, class_name: "User", foreign_key: :author_id, optional: true
  has_one_attached :tldr_image

  validates :title, presence: true, length: {minimum: TITLE_MIN, maximum: TITLE_MAX}

  validates :tldr, length: {maximum: TLDR_MAX}

  validate :check_image, :check_tags

  validates :body, presence: true, length: {minimum: BODY_MIN}

  before_save do |record|
    record.title.strip!
    record.body.strip!
    record.tldr = record.tldr.blank? ? nil : record.tldr.strip
  end

  def self.search(q=nil, tags: nil, author: nil)
    query = search_by_tags tags
    query = search_by_author(query, author)
    q.blank? ? query : omnisearch(query, q)
  end

  alias_method :owner, :author

  private
  def check_image
    return unless tldr_image.attached?

    size = tldr_image.blob.byte_size
    content_type = tldr_image.blob.content_type
    
    if size > TLDR_IMAGE_MAX
      append_tldr_image_error "is #{size} bytes, max is #{TLDR_IMAGE_MAX}"
    end
    unless content_type.starts_with?('image/')
      append_tldr_image_error "must be image, uploaded file with type #{content_type}"
    end
  end

  def append_tldr_image_error(str)
    tldr_image.purge
    errors[:tldr_image] << str
  end
  
  def check_tags
    count = tags.count
    errors[:tags] << "have a maximum of #{TAGS_MAX} (submitted #{count})" if count > 5
    errors[:tags] << "has duplicates" if tags.map(&:id).uniq.count < count
  end

  class << self
    private
    def self.search_by_tags(tags, query=nil)
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

    def self.join
      Article.includes(:tags).left_outer_joins(:author)
    end
    
    def self.omnisearch(query_chain, q)
      query_chain.where "title ilike :q or tldr ilike :q or body ilike :q", q: "%#{q}%"
    end

    def self.search_by_author(query_chain, author)
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
