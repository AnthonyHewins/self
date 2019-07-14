module ApplicationHelper
  def most_popular_user
    id = User.by_popularity.limit(1).pluck(:id).first
    id.nil? ? nil : user_path(id: id)
  end
end
