class Api::V1::UsersController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def create
    @user = User.new(user_params)
    if @user.save
      render json:{
        success:true,
        user: @user
      },except:[:password]
    else
      render json:{
        success:false,
        errors: @user.errors
      }
    end
  end

  def login
      @token = Auth.authenticate(login_params[:id],login_params[:password])
          if @token
            render json: {success: true,
                          auth: {
                              token: @token.token,
                              expires: @token.expires
                            },
                        user: @token.user
                        }, except: [:password, :salt]

        else
          render json: {success: false,
                        errors: ['nombre de usuario o contraseña invalidos']
          }, status: 401

        end
  end


  private

  def login_params
    params.require(:user).permit(:id,:password)
  end

  def user_params
     params.require(:user).permit(:username, :name, :password, :password_confirmation ,:email)
  end
end
