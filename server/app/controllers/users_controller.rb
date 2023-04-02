class UsersController < ApplicationController

  def index
    @users = User.all

    render json: @users
  end

  def create
    @user = User.create(user_params)

    render json: @user, status: :created
  end

  def login
    @user = User.find_by(email: params[:user][:email])

    if @user && @user.authenticated(params[:user][:password])
      @token = JWT.endcode({user_id: @user.id}, Rails.application.secrets.secret_key_base[0])

      render json: { user: @user, token: @token}
    else
      render json: {error: 'Invalid Credentials. Try again'}, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :email)
  end

end
