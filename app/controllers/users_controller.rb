class UsersController < ApplicationController

    before_action :logged_in_user, only: [:edit, :update]

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_path
    else
      render :new, :notice => "El usuario no se pudo crear"
    end
  end

  def login
      @user = User.authenticate(login_params[:id],login_params[:password])
      if @user && @user.activated?
          session[:user_id] = @user.id
          unless @user.admin?
            redirect_to "/#{@user.username}/posts"
          else
            redirect_to "/users/all"
          end
      else
          redirect_to root_path, notice: "Verifique usuario o contraseña"
      end
  end

  def logout
    session.delete(:user_id)
    redirect_to root_path
  end


  def new
    @user = User.new
  end

  def show
    @user = User.find_by(username: params[:id])
    @user = current_user unless params[:id]
  end

  def index
    unless current_user.admin?
      @users = User.where.not(id: current_user.id) #Busca los usuarios excepto el current_user
      @friends = [] # creo un arreglo de amigos
      for friend in current_user.friendships  # recorro los amigos del current_user para agregarlos al arreglo
        @friends << friend.friend_id
      end
      @users = @users.where.not(id: @friends) # alamacena todos los usuarios excepto los amigos
    else
      @users = User.where.not(id: current_user.id)
    end
  end

  def edit
      @user = User.find_by(username: params[:id])
  end

  def update
    @user = current_user
    if @user.update(update_params)
      flash[:success] = "Perfil actualizado!"
      redirect_to "/#{current_user.username}"
    else
      flash[:danger] = "No puedes modificar otro usuario"
      redirect_to "/#{current_user.username}"
    end
  end


  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to "/users/all"
  end

  private

  def logged_in_user
      unless logged_in?
        flash[:danger] = "Porfavor ingresa para acceder"
        redirect_to root_path
      end
  end


  def login_params
      params.require(:user).permit(:id,:password)
  end

  def update_params
    params.require(:user).permit(:name, :username, :email, :picture)
  end

  def user_params
    params.require(:user).permit(:name, :username, :password, :email, :password_confirmation)
  end
end
