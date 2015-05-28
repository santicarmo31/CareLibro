class PostsController < ApplicationController
    before_filter :authenticate!# Se deber autenticar para usar estos metodos only [:create,:new,:destroy,:edit,:update,:show]
  def new
    @post = Post.new
  end

  def index
      @friends = [] #creo arreglo de mis amigos
      for friend in current_user.friendships
        @friends.push(friend.friend_id)
      end
      @posts = Post.where(["user_id IN (:friends) OR user_id = :current_user",friends: @friends, current_user: current_user.id])
      @posts = @posts.reorder(created_at: :asc)

      if params[:search]
        @search = "%#{params[:search]}%"
        @posts = Post.where(["description LIKE :search OR title LIKE :search",search: @search])
      end
      @posts = @posts.paginate(:page => params[:page])
  end

  def create
    @post = Post.new(post_params)
      @post.user = current_user
    if @post.save
      redirect_to @post
    else
      render :new, notice: "No se pudo crear el post intente mas tarde"
    end
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
      if params[:comment] # lo que le paso por la url
          @comment = Comment.find(params[:comment])
      else
        @comment = @post.comments.build # construir un comentario en el post que le pase
      end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post
    else
      render :show
    end

  end

    def destroy
        @post = Post.find(params[:id])
        if @post.destroy
            redirect_to "/#{current_user.username}/posts"
        else
            render :index, notice: "No se borro el post"
        end
    end


  private


  def post_params
    params.require(:post).permit(:title, :description)
  end
end
