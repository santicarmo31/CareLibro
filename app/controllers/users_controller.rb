class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to :posts
    else
      render :new, :notice => "El usuario no se pudo crear"
    end
  end

  def login
      @user = User.authenticate(login_params[:id],login_params[:password])
      if @user
          session[:user_id] = @user.id
          redirect_to posts_path
      else
          redirect_to root_path, notice: "Verifique usuario o contraseña"
      end
  end

  def logout
    session.delete(:user_id)
    redirect_to :posts
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by(username: params[:id])
  end

  def index
    @users = User.where.not(id: current_user.id) #Busca los usuarios excepto el current_user
    @friends = [] # creo un arreglo de amigos
    for friend in current_user.friendships  # recorro los amigos del current_user para agregarlos al arreglo
       @friends << friend.friend_id
    end
    @users = @users.where.not(id: @friends) # alamacena todos los usuarios excepto los amigos
  end

  def edit
    @user = User.find_by(username: params[:id])
  end

  def update
    @user = current_user
    if @user.update(update_params)
      redirect_to current_user
    end
  end

  def destroy
    @user = User.find(params[:id]).destroy
  end

  private

    def login_params
        params.require(:user).permit(:id,:password)
    end

    def update_params
      params.require(:user).permit(:name, :username, :email)
    end
  def user_params
    params.require(:user).permit(:name, :username, :password, :email)
  end
end
