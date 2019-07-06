module ApplicationHelper
  def most_popular_user
    id = find_most_poppin_user
    byebug
    id.nil? ? nil : user_path(id: id)
  end

  private
  def find_most_poppin_user
    User.joins(:articles)
      .group('users.id')
      .order(Arel.sql('sum(articles.views) desc'))
      .limit(1)
      .pluck(:id).first
  end
end
