class Admin::RequestsController < ApplicationController
  layout 'admin'
  before_action :auth_admin


  def index
    @requests = Request.all.page(params[:page] || 1).per_page(params[:per_page] || 10).order(id: "desc")
  end

  def update
    @request = Request.find(params[:id])
    @user = User.find(@request.user_id)
    @user.role = 'delivery'
    @user.password_confirmation = @user.password
    if @user.save
      flash[:notice] = '成功通过'
      @request.destroy!
    else
      flash[:notice] = '出现了未知错误'
    end
    redirect_to admin_requests_path
  end

  def destroy
    @request = Request.find(params[:id])
    @request.destroy!
    flash[:notice] = '撤销成功'
    redirect_to admin_requests_path
  end
end
