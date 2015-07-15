class Api::V1::FriendshipsController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def create
    # render json:{current_user:current_user}
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
    if @friendship.save
      render json:{
        success:true
      }
    else
      render json:{
        success:false
      }
    end
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    flash[:notice] = "Removed friendship."
    redirect_to "/#{current_user.username}"
  end
end
