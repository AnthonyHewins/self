class PermissionModel < ApplicationRecord
  self.abstract_class = true

  def owner
    raise NotImplementedError
  end
end
