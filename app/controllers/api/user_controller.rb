class Api::UserController < ApplicationController
  skip_before_action :require_authorization!, only: [:login, :register]

  def login
    if User.exists?(email: params[:user][:email], password: params[:user][:password])
      render json: {
          token: User.where(email: params[:user][:email]).first.token,
          email: params[:user][:email]
      }, status: :ok
    else
      #render json: { error: 'Invalid login.' }, status: :unauthorized
      render json: { error: 'Invalid login.' }, status: :bad_request
    end
  end

  def register
    #TO-DO real register
    unless User.exists?(email: params[:user][:email])
      @user = User.new(email: params[:user][:email], password: params[:user][:password])
      if @user.valid?
        @user.save
        render json: {
            token: @user.token,
            email: @user.email
          }, status: :ok
      else
        render json: { error: @user.errors.messages}, status: :bad_request
      end
    else
      render json: { error: 'Email already exists'}, status: :bad_request
    end
  end
end
