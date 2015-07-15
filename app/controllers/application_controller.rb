class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #include ActionController::HttpAuthentication::Token::ControllerMethods

  def authenticate!
  if !logged_in?
    respond_to do |format|
      format.json {
        render json: { success:false, errors: ['No tienes acceso a esta parte, inicia sesion'] }, status: 401
      }

      format.html {
        redirect_to root_url, alert: "No tienes acceso a esta parte, inicia sesion. (401)"
      }
    end

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
      @current_user ||= User.find_by_email(session[:email]) if session[:user_id]

      @current_user ||= authenticate_with_http_token do |token, options|
        context = Auth.find_by token: token

        return context.user if context
        return nil
      end
    end
    helper_method :current_user, :logged_in?

end
