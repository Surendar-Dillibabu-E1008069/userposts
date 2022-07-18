class Post < ActiveRecord::Base
  belongs_to :user
  attr_accessible :content, :title, :user_id

  validates :title,
           :presence => { :message => "Title is mandatory" }
  validates :content,
            :presence => { :message => "Content is mandatory" },
            :length => { :minimum => 10, :maximum => 400, :message => "Content should contain minimum 10 characters and maximum 400 characters" }

  def self.post_id_list_by_user(user_id)
    where(" user_id = ?", user_id).collect { |p| p.id }
  end
end
