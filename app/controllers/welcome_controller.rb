class WelcomeController < ApplicationController
  def home
    if current_user
      redirect_to "/#{current_user.username}/posts"
    end
    #a = User.all
    #render json: a.second,only: [:password,:salt]
  end
end
