class CommentsController < ApplicationController
  before_action :auth_user
  def index
    @comments = Comment.by_user_id(session[:user]).page(params[:page] || 1).per_page(params[:per_page] || 10)
  end

  def update
    @comment = Comment.find(params[:id])
    unless @comment.user_id == current_user.id
      flash[:notice] = '请不要尝试修改他人的评论'
      redirect_to root_path
    end
    if @comment.update(content: params[:comment][:content])
      flash[:notice] = "评论修改成功"
    else
      flash[:notice] = "修改失败，评论不能为空"
    end
    redirect_to comments_path
  end


  def edit
    @comment = Comment.find(params[:id])
  end

  def create
    @comment = Comment.new
    @comment.product_id = params[:product_id]
    @comment.user_id = current_user.id
    @comment.content = params[:content]
    if @comment.save
      flash[:notice] = "评论成功"
    else
      flash[:notice] = "评论不能为空"
    end
    redirect_back fallback_location: root_path
  end
  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user_id == current_user.id
      @comment.destroy!
      flash[:notice] = '删除成功'
      redirect_to comments_path
    else
      flash[:notice] = '请不要尝试删除他人的评论'
      redirect_to root_path
    end
  end
end
