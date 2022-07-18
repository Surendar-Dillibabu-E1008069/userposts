class PostsController < ApplicationController
  before_filter :set_post, only: %i[ show edit update ]

  def index
    user_id = session[:user_id]
    @followers_list = Follower.follower_id_list_by_user(user_id)
    user_id_list = [ user_id ]
    user_id_list.concat(@followers_list)
    @posts = Post.where(" user_id in (?)", user_id_list)
    @users = User.where(" id != ?", user_id)
    @follower = Follower.new
  end

  def new
    @post = Post.new
  end

  def show
  end

  def create
    @post = Post.new(params[:post])
    if @post.save
      redirect_to posts_path, notice: "Post was successfully created"
    else
      render :new
    end
  end

  def edit
    post_id_list = Post.post_id_list_by_user(session[:user_id])
    if post_id_list.include?params[:id].to_i
      puts "Post present"
    else
      redirect_to access_denied_path
    end
  end

  def update
    result = @post.update_attributes(:title => params[:post][:title],
                                     :content => params[:post][:content],
                                     :user_id => params[:post][:user_id])
    if result
      redirect_to @post, notice: "Post was successfully updated"
    else
      render  :edit, status:  :unprocessable_entity
    end
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

end
