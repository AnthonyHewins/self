module ApplicationHelper
  def most_popular_user
    id = User.by_popularity.limit(1).pluck(:id).first
    id.nil? ? nil : user_path(id: id)
  end

  def select_in_dropdown(var)
    case var
    when Symbol
      preselect_in_dropdown(params[var].split(',').map {|i| Integer(i)}) rescue nil
    when ActiveRecord::Relation
      preselect_in_dropdown var.map(&:id)
    when Integer
      jquery_str(var).html_safe
    when NilClass
      var
    else
      raise TypeError
    end
  end

  private
  def preselect_in_dropdown(ints)
    ints.map {|i| jquery_str(i)}.join(',').html_safe
  end

  def jquery_str(var)
    "'#{var}'"
  end
end
