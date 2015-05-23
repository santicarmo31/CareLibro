class PostsController < ApplicationController
    before_filter :authenticate!,# Se deber autenticar para usar estos metodos only [:create,:new,:destroy,:edit,:update,:show]
  def new
    @post = Post.new
  end

  def index
      @posts = Post.where(user: User.find_by(username: params[:user_id]))
      if !@posts.any? && current_user
        @friends = []
        for friend in current_user.friendships
          @friends << friend.friend_id
        end
        if @friends.any?
          @posts = Post.where(["user_id IN (:u) OR user_id = :f",u: @friends, f: current_user])
        else
          @posts = Post.where(user: current_user)
        end
      end

      if params[:search]
        x = "%#{params[:search]}%" # para meter una variable dentro de un string, los modulos son para buscar alguna coincidencia de la palabra
        @posts = @posts.where(["title like :t", t: x]) # like = parecido a lo que le pase
      end
      @posts = @posts.order(created_at: :asc) # Ordena ascendentemente
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
      if params[:comment]
          @comment = Comment.find(params[:comment])
      else
        @comment = @post.comments.build
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
            redirect_to :posts
        else
            render :index, notice: "No se borro el post"
        end
    end


  private


  def post_params
    params.require(:post).permit(:title, :description)
  end
end
