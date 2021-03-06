class PostsController < ApplicationController

  before_action:forbid_user
  before_action:restrict_user,{only: [:edit, :update, :destroy]}

  def news
    @posts = Post.all.order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(content: params[:content])
    @post.user_id = @current_user.id
    if@post.save
      redirect_to("/posts/news")
    else
      render("posts/new")
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    @user = User.find_by(id: @post.user_id)
  end

  def edit
    @post = Post.find_by(id: params[:id])
    @user = User.find_by(id: @post.user_id)
  end

  def update
    @post = Post.find_by(id: params[:id])
    @post.content = params[:content]
    if @post.save
      flash[:notice] = "更新しました"
      redirect_to("/posts/#{@post.id}")
    else
      flash[:notice] = "編集は無効です"
      render("posts/edit")
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to("/posts/news")
  end

  def restrict_user
    @post = Post.find_by(id: params[:id])
    if @current_user.id != @post.user_id
      flash[:notice] = "やめてー！"
      redirect_to("/posts/#{@post.id}")
    end
  end



end
