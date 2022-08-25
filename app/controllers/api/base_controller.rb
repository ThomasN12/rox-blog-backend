class Api::BaseController < ApplicationController
  # before_action :authorized
  def current_user
    return nil unless token_verified

    @current_user ||= User.find_by_id(token_verified["user_id"])
  end
end
