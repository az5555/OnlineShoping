class Admin::OrdersController < ApplicationController

  layout "admin"
  before_action :auth_admin

  def index
    @orders = Order.all.page(params[:page] || 1).per_page(params[:page] || 10).order(id: "desc")
    @users = User.deliver
  end

  def new
    @order = Order.new
  end



  def edit
    @order = Order.find(params[:id])
  end

  def update
    if params[:user][:id].blank?
      flash[:notice] = "请选择配送对象"
      redirect_to admin_orders_path
      return
    end
    @order = Order.find(params[:id])
    @user = User.deliver.find(params[:user][:id])
    if @order.update(:status => 1, :deliver_id => params[:user][:id], :deliver_name => @user.username)
      flash[:notice] = "修改成功"
    else
      flash[:notice] = "修改失败"
    end
    redirect_to admin_orders_path
  end

  def destroy
    @orders = Order.all.page(params[:page] || 1).per_page(params[:per_page] || 5).order(id: "desc")
    @order = Order.find(params[:id])
    @product = @order.product
    @status = @order.status
    if @status == 0 && !@product.nil?
      @product.count = @product.count + @order.amount
      @product.save
    end
    if @order.destroy!
      flash[:notice] = "删除成功"
    end
    redirect_to admin_orders_path
  end
end
