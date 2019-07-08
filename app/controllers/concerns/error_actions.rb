module Concerns
  module ErrorActions
    protected
    def error(obj, render_path)
      flash.now[:red] = obj
      render render_path
    end
  end
end
