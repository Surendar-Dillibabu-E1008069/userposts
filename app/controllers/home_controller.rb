class HomeController < ApplicationController

  def index
    @user = User.find(session[:user_id])
  end

  def logout
    session[:user_id] = nil
    redirect_to login_path
  end

  def access_denied
  end

end
