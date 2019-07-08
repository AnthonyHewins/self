module Concerns
  module Permission
    class AccessDenied < RuntimeError; end

    def set_and_authorize
      raise AccessDenied if current_user.nil?
      instance_var = get_instance_var
      raise AccessDenied unless current_user.has_permission? instance_var

      instance_variable_set("@" + controller_name.classify.underscore, instance_var)
    end

    def authorize
      raise AccessDenied if current_user.nil?
    end
    
    private
    def get_instance_var
      model = controller_name.classify.constantize
      model.find params[:id]
    end
  end
end
