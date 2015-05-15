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
          redirect_to root_path
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
    @user = User.find_by(:username)
  end

  def index
    @users = User.where(User.find_by(:username))
  end

  def destroy
    @user = User.find(params[:id]).destroy
  end

  private

    def login_params
        params.require(:user).permit(:id,:password)
    end

  def user_params
    params.require(:user).permit(:name, :username, :password, :email)
  end
end
