class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

    def authenticate!
        if !logged_in?
            redirect_to root_path, alert: "logeate pirobo"
        end
    end


    private

    def logged_in?
        return true if current_user.present?
    end

    def current_user?(user)
      user == current_user
    end

    def current_user
        @current_user = User.find(session[:user_id]) if(session[:user_id])

    end
    helper_method :current_user, :logged_in?

end
