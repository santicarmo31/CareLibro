class PostsController < ApplicationController
    before_filter :authenticate!,only: [:create,:new,:destroy,:edit,:update] #Se deber autenticar para usar estos metodos
  def new
    @post = Post.new
  end

  def index
    @posts = Post.where(user: User.find_by(username: params[:user_id]))
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
