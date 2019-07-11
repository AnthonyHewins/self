require 'concerns/permission'

module Authenticate
  def authenticate
    expect{yield}.to raise_error Concerns::Permission::AccessDenied
  end
end
