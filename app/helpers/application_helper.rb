module ApplicationHelper
  # Bulma color helpers
  WHITE = "is-white"
  BLACK = "is-black"
  LIGHT = "is-light"
  DARK = "is-dark"
  PRIMARY = "is-primary"
  INFO = "is-info"
  LINK = "is-link"
  SUCCESS = "is-success"
  WARNING = "is-warning"
  DANGER = "is-danger"
  
  def uid(model)
    return nil if model.nil?
    raise TypeError, "#{model} isn't a descendant of ActiveRecord::Base" unless model.class < ActiveRecord::Base
    "#{model.class.to_s.downcase}#{model.id}"
  end
end
