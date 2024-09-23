class OrdersController < ApplicationController
  before_action :auth_user

  def index
    @orders = Order.all.by_user_id(session[:user])
                   .page(params[:page] || 1).per_page(params[:per_page] || 10).order(id: "desc")
  end

  def new
    @order = Order.new
  end

  def create
    @shopping_carts = ShoppingCart.by_user_id(session[:user])
                                  .order(id: "desc").includes(:product)
    @shopping_carts.each do |shopping_cart|
      unless shopping_cart.product.nil?
        @product = shopping_cart.product
        @order = Order.new
        @order.amount = shopping_cart.amount
        if shopping_cart.amount > @product.count
          flash[:notice] = "存在购买数量超出库存，请检查后购买"
          redirect_to shopping_carts_path
          return
        else
          @product.count = @product.count - shopping_cart.amount
          @order.user_id = shopping_cart.user_id
          @order.user_name = current_user.username
          @order.product_id = shopping_cart.product_id
          @order.product_name = @product.name
          @order.total_money = shopping_cart.amount * @product.price
          @order.pay_time = Time.now
          @order.address = current_user.address
          @product.save!
          @order.save!
        end
      end
      shopping_cart.destroy!
    end
    if flash[:notice].blank?
      flash[:notice] = "购买成功"
    end
    redirect_to root_path
  end

  def update
    @order = Order.find(params[:id])
    if @order.user_id != current_user.id
      flash[:notice] = "不要修改他人订单"
    elsif @order.status != 1
      flash[:notice] = "商品还未派送呢"
    elsif @order.update(:status => 2)
      user = @order.user
      user.password_confirmation = user.password
      user.total_money = user.total_money + @order.total_money
      user.save!
      flash[:notice] = "修改成功"
    else
      flash[:notice] = "修改失败"
    end
    redirect_to orders_path
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.user_id != current_user.id
      flash[:notice] = "不要修改他人的订单"
      redirect_to orders_path
      return
    end
    if @order.status == 1
      flash[:notice] = "配送状态的订单无法修改"
      redirect_to orders_path
      return
    end
    if @order.status != 2 && @order.product
      @product = @order.product
      @product.count = @product.count + @order.amount
      @product.save!
    end
    if @order.destroy!
      flash[:notice] = "删除成功"
    end
    redirect_to orders_path
  end
end
