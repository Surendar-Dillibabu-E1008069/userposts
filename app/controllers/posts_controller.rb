class PostsController < ApplicationController
  before_filter :set_post, only: %i[ show edit update ]

  def index
    user_id = session[:user_id]
    if user_id == nil
      user_id = params[:userId];
    end
    @followers_list = Follower.follower_id_list_by_user(user_id)
    user_id_list = [ user_id ]
    user_id_list.concat(@followers_list)
    @posts = Post.where(" user_id in (?)", user_id_list)
    @users = User.where(" id != ?", user_id)
    @follower = Follower.new
    data = {
      "posts": @posts,
      "users": @users,
      "followers_list": @followers_list
    }

    respond_to do |format|
      format.html { render :index }
      format.json { render json: data }
    end
  end

  def new
    @post = Post.new
  end

  def show
    respond_to do |format|
      format.html { render :'posts/show' }
      format.json { render json: @post }
    end
  end

  def create
    @post = Post.new(params[:post])
    if @post.save
      respond_to do |format|
        format.html { redirect_to posts_path,  notice: "Post was successfully created"}
        format.json { render json: { "succMsg": "Post was successfully created" } }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { "errMsg": "Post creation failed. Please try later" } }
      end
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
    puts "update #{@post}"
    result = @post.update_attributes(:title => params[:post][:title],
                                     :content => params[:post][:content],
                                     :user_id => params[:post][:user_id])
    if result
      respond_to do |format|
        format.html { redirect_to @post,  notice: "Post was successfully updated"}
        format.json { render json: { "succMsg": "Post was successfully updated" } }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: { "succMsg": "Post updation failed. Please try later" } }
      end
    end
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

end
