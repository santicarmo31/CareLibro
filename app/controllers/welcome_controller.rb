class WelcomeController < ApplicationController
  def home
    if current_user
      redirect_to "/#{current_user.username}/posts"
    end
  end
end
