class ShoppingCartsController < ApplicationController
  before_action :auth_user

  def index
    @shopping_carts = ShoppingCart.by_user_id(session[:user])
                                  .order(id: "desc")
  end

  def create
    amount = params[:amount].to_i
    amount = amount <= 0 ? 1 : amount

    @product = Product.find(params[:product_id])
    @shopping_cart = ShoppingCart.create_or_update(
      {user_id: session[:user], product_id: params[:product_id], amount: amount })

    flash[:notice] = "添加成功"

    redirect_back fallback_location: root_path
  end


  def update
    @shopping_carts = ShoppingCart.by_user_id(session[:user])
                                  .order(id: "desc")
    @shopping_cart = ShoppingCart.find(params[:id])
    if @shopping_cart
      amount = params[:amount].to_i
      amount = amount <= 0 ? 1 : amount
      if @shopping_cart.user_id != current_user.id
        flash[:notice] = "不要修改他人购物车"
        redirect_back fallback_location: root_path
        return
      end
      @shopping_cart.update(amount: amount)
      flash[:notice] = "添加成功"
    end

    redirect_to shopping_carts_path
  end

  def destroy
    @shopping_carts = ShoppingCart.by_user_id(session[:user])
                                  .order(id: "desc")
    @shopping_cart = ShoppingCart.find(params[:id])
    if @product.user_id != current_user.id
      flash[:notice] = "不要修改他人购物车"
      redirect_to shopping_carts_path
      return
    end
    @shopping_cart.destroy if @shopping_cart
    flash[:notice] = "删除成功"
    redirect_to shopping_carts_path
  end
end
