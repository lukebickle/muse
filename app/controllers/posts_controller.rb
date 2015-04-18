class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  #from devise - anything they try to do that a user is not authorized to, they will get routed to the sign in page

  def index
    @posts = Post.all.order("created_at DESC")
  end

  def show
    @comments = Comment.where(post_id: @post)
  end

  def new
    @post = current_user.posts.build  #@post = Post.new = helps with the user-id colomn being filled in
  end

  def create
    @post = current_user.posts.build(post_params)   #@post = Post.new(post_params)
    # makes sure the user id column in the post table is filled in when we create a post
    # add before_action from devise - authe.

    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params

    params.require(:post).permit(:title, :link, :description, :image)
  end
end
