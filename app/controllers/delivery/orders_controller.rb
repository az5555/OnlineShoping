class Delivery::OrdersController < ApplicationController
  before_action :auth_delivery

  def index
    @orders = Order.waiting.page(params[:page] || 1).per_page(params[:per_page] || 10).order(id: "desc")
  end

  def new
    @order = Order.new
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(:status => 1, :deliver_name => current_user.username, :deliver_id => current_user.id)
      flash[:notice] = "接单成功"
    else
      flash[:notice] = "接单失败"
    end
    redirect_to delivery_orders_path
  end

  def my_order
    @orders = Order.by_deliver_id(deliver_id: current_user.id)
  end
end
