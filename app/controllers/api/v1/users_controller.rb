# User's controller
class Api::V1::UsersController < ApplicationController
  respond_to :json

  def show
    @user = User.find(params[:id])
    respond_with @user
  rescue
    head 404
  end

  def create
    user = User.new(user_params)

    return render json: { errors: user.errors }, status: 422 unless user.save
    render json: user, status: 201
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
