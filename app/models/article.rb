class Article < PermissionModel
  TITLE_MIN = 10
  TITLE_MAX = 1000

  TLDR_MAX = 1500

  BODY_MIN = 128

  has_and_belongs_to_many :tags
  belongs_to :author, class_name: "User", foreign_key: :author_id, optional: true

  validates :title, presence: true, length: {minimum: TITLE_MIN, maximum: TITLE_MAX}

  validates :tldr, length: {maximum: TLDR_MAX}

  validates :body, presence: true, length: {minimum: BODY_MIN}

  has_one_attached :tldr_image

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
  def self.search_by_tags(tags)
    case tags
    when Array, ActiveRecord::Relation
      tags = tags.map(&:id) if tags.first.instance_of?(Tag)
      join tags
    when Integer
      join.where "articles_tags.tag_id = ?", tags
    when Tag
      join.where "articles_tags.tag_id = ?", tags.id
    when NilClass
      join
    else
      raise TypeError
    end
  end

  def self.join(ids=nil)
    return Article.left_outer_joins(:tags, :author) if ids.nil?
    ids.map! {|i| Integer(i)}.uniq
    join_query = ids.map do |id|
      "inner join articles_tags t#{id} on t#{id}.article_id = articles.id and
       t#{id}.tag_id = #{id}"
    end
    Article.left_outer_joins(:author).joins(
      "#{join_query.join(' ')}
       left outer join users on users.id = articles.author_id"
    )
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
