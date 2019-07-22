module Concerns
  module Permission
    class AccessDenied < RuntimeError; end

    protected
    def authorize
      raise AccessDenied if current_user.nil?
    end

    def admin_only
      authorize
      raise AccessDenied unless current_user.admin?
    end

    def set_and_authorize
      authorize
      get_instance_var
    end

    def mod_as_admin
      admin_only
      get_instance_var
    end

    private
    def get_instance_var
      model = controller_name.classify.constantize
      var = model.find params[:id]
      raise AccessDenied unless current_user.has_permission? var
      instance_variable_set("@" + controller_name.classify.underscore, var)
    end
  end
end
