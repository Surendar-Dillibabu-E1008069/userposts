class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }
  before_filter :authenticate_user, unless: -> { request.format.json? }

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
    if request.format.json?
      if user_id == nil
        user_id = params[:userId];
        if user_id == nil
          user_id = params[:id]
        end
      end
      @user = User.find(user_id)
    elsif user_id == nil
      redirect_to login_path
    else
      @user = User.find(user_id)
    end
  end

end