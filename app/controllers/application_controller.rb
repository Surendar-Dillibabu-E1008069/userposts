class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user

  def index
    user_id = session[:user_id]
    if user_id == nil
      redirect_to login_url
    else
      redirect_to home_path
    end
  end

  def authenticate_user
    user_id = session[:user_id]
    if user_id == nil
      redirect_to login_path
    else
      @user = User.find(user_id)
    end
  end

end