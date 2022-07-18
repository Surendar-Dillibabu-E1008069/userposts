class Follower < ActiveRecord::Base
  belongs_to :user
  attr_accessible :follower_user_id, :user_id

  def self.follower_id_list_by_user(user_id)
    where(" user_id = ?", user_id).collect{ |f| f.follower_user_id }
  end

  def self.unfollow_user(follower_user_id, user_id)
    where(" follower_user_id = :follower_user_id and user_id = :user_id",
          :follower_user_id => follower_user_id,
          :user_id => user_id).destroy_all
  end
end
