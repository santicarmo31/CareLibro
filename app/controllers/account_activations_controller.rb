class AccountActivationsController < ApplicationController
  def edit
        token = params[:id]
        user = User.find_by(activation_digest: token)
          if user && !user.activated?
            user.activated = true
            user.activation_digest = nil
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

end
