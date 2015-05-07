class CommentsController < ApplicationController
  def create
   @comment = Comment.new (comment_params)
   if @comment.save
     redirect_to post_path(comment_params[:post_id])
   else
     redirect_to post_path, notice: "No se creo el comentario"
   end
  end



  private

  def comment_params
    params.require(:comment).permit(:description, :post_id)
  end


end
