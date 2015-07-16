class Api::V1::FriendshipsController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def create
    # render json:{current_user:current_user}
    @user = User.find_by(username: params[:username])
    @friendship = current_user.friendships.build(friend_id: @user.id)
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
    @friendship = current_user.friendships.find_by(friend_id: params[:id])
    if @friendship.destroy
      render json:{
        success:true
      }else {
        success:false
      }
    end

  end
end
