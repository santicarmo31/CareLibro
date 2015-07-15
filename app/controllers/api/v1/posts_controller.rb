class Api::V1::PostsController < ApplicationController

  skip_before_filter :verify_authenticity_token


  def create
    @post = Post.new(post_params)
    @post.user = current_user
      if @post.save
        render json:{
          success:true,
          post: @post
        }
      else render json:{
        success:false
        }
      end
  end

  def index
    @posts = Post.where(user_id: current_user)
    render json: @posts
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      render json:{
        success:true,
        post: @post
      }
    else render json:{
      success:false
      }
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      render json:{
        success:true
      }
    else render json:{
        success:false
      }
    end
  end




  private


  def post_params
    params.require(:post).permit(:title, :description)
  end
end
