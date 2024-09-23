class Admin::CommentsController < ApplicationController

  layout "admin"
  before_action :auth_admin
  def index
    @comments = Comment.all.page(params[:page] || 1).per_page(params[:per_page] || 10)
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(content: params[:comment][:content])
      flash[:notice] = "评论修改成功"
      redirect_to admin_comments_path
    else
      flash[:notice] = "修改失败，评论不能为空"
      redirect_back fallback_location: root_path
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def create
    @comment = Comment.new
    @comment.product_id = params[:product_id]
    @comment.user_id = current_user.user_id
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
    @comment.destroy!
    flash[:notice] = '删除成功'
    redirect_to admin_comments_path
  end
end
