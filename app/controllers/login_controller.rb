class LoginController < ApplicationController
  before_filter :authenticate_user, except: %i[ index login ]

  def index
    user_id = session[:user_id]
    if user_id != nil
      redirect_to home_path
    end
  end

  def login
    @email = params[:email]
    @password = params[:password]
    respond_to do |format|
      if @email.present? && @password.present?
        @user = User.find_by_email(@email)
        if @user != nil && @user.password == @password
          session[:user_id] = @user.id
          format.html { redirect_to "/home" }
        else
          format.html { redirect_to login_path, notice: "Please check your email or password" }
        end
      else
        format.html { redirect_to login_path, notice: "Please provide the email and password" }
      end
    end
  end
end
