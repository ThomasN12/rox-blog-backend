# class Api::UsersController < ApplicationController
class Api::UsersController < Api::BaseController
  # before_action :authorized, only: %i[ show ]
  before_action :set_user, only: %i[ show update ]
  before_action :is_same_user, only: %i[ update ]

  def index 
    @users = User.all
    response_success({ users: each_serializer_modal(@users, UserSerializer) })
  end

  def show
    if @user
      response_success({ user: serializer_modal(@user, UserSerializer) })
    else
      response_failed(:not_found, ["User not found"])  
    end
  end

  # def create
  #   @user = User.new(user_params)
  #   if @user.save
  #       msg = "Hi #{@user.username}, welcome to Alpha Blog!"
  #       response_success({ user: serializer_modal(@user, UserSerializer), 
  #                       token: encode_token_user(@user)}, msg)
  #   else 
  #       response_failed(:ok, @user.errors.full_messages)
  #   end

  # end

  def update
    # @user = User.find(params[:id])
    if @user.update(user_params)
      msg = "You have successfuly updated your profile"
        response_success({ user: serializer_modal(@user, UserSerializer)}, msg)
    else 
      response_failed(:ok, @user.errors.full_messages)
    end
  end

  def current_user_info
    if current_user
      response_success({ user: serializer_modal(current_user, UserSerializer) })
    else
      response_failed(:ok, ["Not logged in"])
    end
  end


  private

    # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user ||= User.find_by_id(params[:id])
  end

  def user_params
    params.permit(:username, :email, :password)
  end

  def is_same_user
    return response_failed(:unauthorized, ["You must be logged in to update article"]) unless current_user
    # return response_failed(:unauthorized, ["You are not authorized to edit this article"]) unless current_user.id == @article.user.id
    return response_failed(:unauthorized, ["You are not authorized to edit this user's profile"]) unless current_user == @user
  end  
end
