module ApplicationHelper
  def uid(model)
    return nil if model.nil?
    raise TypeError, "#{model} isn't a descendant of ActiveRecord::Base" unless model.class < ActiveRecord::Base
    "#{model.class.to_s.downcase}#{model.id}"
  end
end
