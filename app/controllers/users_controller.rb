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
    respond_to do |format|
      format.html { render :'users/show' }
      format.json { render json: @user }
    end
  end

  def edit
    @user.password_confirmation = @user.password
    respond_to do |format|
      format.html { render :'users/edit' }
      format.json { render json: @user }
    end
  end

  def create
    @user = User.new(params[:user])
    existingUser = User.find_by_email(@user.email);
    if existingUser
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { "errMsg": "Given email already present in our system. Please try with different email" } }
      end
    else
      if @user.save
        respond_to do |format|
          format.html { redirect_to new_user_path, notice: "User was successfully created. Please login through nav-bar" }
          format.json { render json: { "succMsg": "User was successfully created. Please login through nav-bar" } }
        end
      else
        respond_to do |format|
          format.html { render :new }
          format.json { render json: { "errMsg": "User creation failed. Please try later" } }
        end
      end
    end

  end

  def update
    result = @user.update_attributes(:first_name => params[:user][:first_name],
                                     :last_name => params[:user][:last_name],
                                     :email => params[:user][:email],
                                     :password => params[:user][:password],
                                     :password_confirmation => params[:user][:password_confirmation])
    if result
      respond_to do |format|
        format.html { redirect_to @user, notice: "User was successfully updated" }
        format.json { render json: { "succMsg": "User was successfully updated." } }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: { "errMsg": "User updation failed. Please try later" } }
      end
    end
  end

  private
  def access_validation
    user_id = params[:id]
    if request.format.json?
    elsif user_id.to_i != session[:user_id]
      redirect_to access_denied_path
    end
  end

end
