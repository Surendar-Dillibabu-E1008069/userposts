class UsersController < ApplicationController
  before_filter :authenticate_user, except: %i[ new create ]
  before_filter :access_validation, only: %i[ show edit ]

  def index
    @users = User.all
  end

  def new
    user_id = session[:user_id]
    if user_id != nil
      redirect_to home_path
    end
    @user = User.new
  end

  def show
  end

  def edit
    @user.password_confirmation = @user.password
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to new_user_path, notice: "User was successfully created. Please login through nav-bar menu"
    else
      render :new
    end
  end

  def update
    result = @user.update_attributes(:first_name => params[:user][:first_name],
                                     :last_name => params[:user][:last_name],
                                     :email => params[:user][:email],
                                     :password => params[:user][:password],
                                     :password_confirmation => params[:user][:password_confirmation])
    if result
      redirect_to @user, notice: "User was successfully updated"
    else
      render  :edit, status:  :unprocessable_entity
    end
  end

  private
  def access_validation
    user_id = params[:id]
    if user_id.to_i != session[:user_id]
      redirect_to access_denied_path
    end
  end

end
