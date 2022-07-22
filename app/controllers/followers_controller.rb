class FollowersController < ApplicationController
  before_filter :set_user_id, only: %i[ follow unfollow ]

  def follow
    puts "follow userId : #{@userId}"
    @follower = Follower.new(:user_id => @userId,
                             :follower_user_id => params[:follower_user_id])
    @follower_user = User.find(@follower.follower_user_id)
    if @follower.save
      respond_to do |format|
        format.html { redirect_to posts_path, notice: "Started following #{@follower_user.first_name}" }
        format.json { render json: { "succMsg": "Started following #{@follower_user.first_name}" } }
      end
    else
      respond_to do |format|
        format.html { redirect_to posts_path, notice: "Can't able to follow #{@follower_user.first_name}. Please try later" }
        format.json { render json: { "errMsg": "Can't able to follow #{@follower_user.first_name}. Please try later" } }
      end
    end
  end

  def unfollow
    puts "unfollow userId : #{@userId}"
    @follower_user = User.find(params[:follower_user_id])
    result = Follower.unfollow_user(params[:follower_user_id], @userId)
    if result
      respond_to do |format|
        format.html { redirect_to posts_path, notice: "Unfollowed #{@follower_user.first_name}" }
        format.json { render json: { "succMsg": "Unfollowed #{@follower_user.first_name}" } }
      end
    else
      respond_to do |format|
        format.html { redirect_to posts_path, notice: "Can't able to unfollow #{@follower_user.first_name}. Please try later" }
        format.json { render json: { "errMsg": "Can't able to unfollow #{@follower_user.first_name}. Please try later" } }
      end
    end
  end

  private
  def set_user_id
    @userId = session[:user_id]

    if @userId == nil
      @userId = params[:userId];
    end
  end

end
