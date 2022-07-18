class FollowersController < ApplicationController

  def follow
    @follower = Follower.new(:user_id => session[:user_id],
                             :follower_user_id => params[:follower_user_id])
    @follower_user = User.find(@follower.follower_user_id)
    if @follower.save
      redirect_to posts_path, notice: "Started following #{@follower_user.first_name}"
    else
      redirect_to posts_path, notice: "Can't able to follow #{@follower_user.first_name}. Please try later"
    end
  end

  def unfollow
    @follower_user = User.find(params[:follower_user_id])
    result = Follower.unfollow_user(params[:follower_user_id], session[:user_id])
    if result
      redirect_to posts_path, notice: "Unfollowed #{@follower_user.first_name}"
    else
      redirect_to posts_path, notice: "Can't able to unfollow #{@follower_user.first_name}. Please try later"
    end
  end

end
