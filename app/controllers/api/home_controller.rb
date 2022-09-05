class Api::HomeController < ApplicationController
  def login
    user = User.find_by_email(login_params[:email])
    if user.nil?
      response_failed(:not_found, ["User's email does not exist"])
    else
    #   if user.status == Constants::USER_STATUS[:BLOCK]
    #     return response_failed(:ok, [I18n.t("api.errors.messages.login_block_failed")])
    #   end
  
      if user&.authenticate(login_params[:password])
        response_success({ user: serializer_modal(user, UserSerializer), token: encode_token_user(user) }, "Logged in successfully")
      else
        response_failed(:ok, ["Your email or password is incorrect"])
      end
    end
  end

  def signup
    @user = User.new(user_params)
    if @user.save
        msg = "Hi #{@user.username}, welcome to Alpha Blog!"
        response_success({ user: serializer_modal(@user, UserSerializer), 
                        token: encode_token_user(@user)}, msg)
    else 
        response_failed(:ok, @user.errors.full_messages)
    end

  end

  def logout
    return response_failed(:ok, ["Logout failed"]) unless token_verified

    token_verified.destroy!

    response_success(nil, "Logged out")
  end  




#   def reset_password
#     ActiveRecord::Base.transaction do
#       token = decode_token_confirm(user_reset_password_params[:token_reset_password])[0]["token"]
#       user_token = UserToken.find_by_token(token)
#       user_token.user.update!(password: user_reset_password_params[:password])
#       response_success(nil, 
#                        I18n.t("api.success.messages.update_success",resource: I18n.t("api.password")))
#       user_token.delete
#     rescue
#       response_failed(:ok, 
#                       [I18n.t("api.errors.messages.update_failed",resource: I18n.t("api.password"))])
#     end
#   end


  private
    
  def login_params
    params.permit(:email, :password)
  end

  def user_params
    params.permit(:username, :email, :password)
  end  
  
end
