class AccountActivationsController < ApplicationController
  def edit
        token = params[:id]
        user = User.find_by(activation_digest: token)
          if user && !user.activated?
            user.activated = true
            user.activation_digest = nil
            user.activated_at = Time.now
            if  user.save
              flash[:success] = "Usuario activado exitosamente."
            else
              flash[:error] = "Usuario no se pudo activar."
            end
          else
            flash[:warning] = "Usuario activado exitosamente."
          end
        redirect_to root_path
  end

  def show
     password_token = params[:id]
     user = User.find_by(password_token: password_token)
     if user && user.password_token == password_token
       user.toggle! :can_edit_password
       redirect_to edit_user_path(user.username)
     end
  end

end
