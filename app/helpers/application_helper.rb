module ApplicationHelper
  def most_popular_user
    id = find_most_poppin_user
    id.nil? ? nil : user_path(id: id)
  end

  private
  def find_most_poppin_user
    User.joins(:articles)
      .group(Arel.sql('users.id, articles.id, articles.author_id'))
      .order(Arel.sql('count(articles.author_id) desc'))
      .limit(1).pluck(:id).first
  end
end
