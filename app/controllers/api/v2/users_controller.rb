# User's controller
class Api::V2::UsersController < ApplicationController
  before_action :authenticate_with_token!, only: %i[update destroy]

  def show
    user = User.find(params[:id])
    render json: user, status: 200
  rescue
    head 404
  end

  def create
    user = User.new(user_params)

    return render json: { errors: user.errors }, status: 422 unless user.save
    render json: user, status: 201
  end

  def update
    user = current_user

    return render json: { errors: user.errors }, status: 422 unless user.update(user_params)
    render json: user, status: 200
  end

  def destroy
    current_user.destroy
    head 204
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
