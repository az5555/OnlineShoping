class Admin::UsersController < ApplicationController
  layout "admin"
  before_action :auth_admin
  def index
    @users = User.all.page(params[:page] || 1).per_page(params[:per_page] || 10).order(id: "desc")
  end

  def update
    @user = User.find(params[:id])
    if @user.status == 1
      @user.status = 0
      flash[:notice] = '解封成功'
    else
      @user.status = 1
      flash[:notice] = '封号成功'
    end
    if @user.save
      redirect_to admin_user_path
    else
      flash[:notice] = '怎么可能失败呢'
      redirect_to admin_users_path
    end
  end
end
