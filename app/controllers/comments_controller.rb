class CommentsController < ApplicationController
    def create
        @comment = Comment.new (comment_params)
        if @comment.save
            redirect_to post_path(comment_params[:post_id])
        else
            redirect_to post_path, notice: "No se creo el comentario"
        end
    end
    
    
    def edit
        @comment =  Comment.find(params[:id])
    end

    def update
        @comment = Comment.find(params[:id])
        if @comment.update(comment_params)
            redirect_to post_path(@comment.post_id)
        end
    end

    def destroy
        @comment = Comment.find(params[:id])
        post_id = @comment.post_id
        if @comment.destroy
            redirect_to post_path(post_id)
        else
            redirect_to :posts, notice: @comment.errors 
        end
    end

    private





    def comment_params
        params.require(:comment).permit(:description, :post_id)
    end
end