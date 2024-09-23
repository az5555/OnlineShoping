class HomeController < ApplicationController
  def index
    @categories = Category.grouped_data
    @products = Product.on_sale.page(params[:page] || 1).per_page(params[:per_page] || 10).order(weight: "desc").
      includes(:main_product_image)
  end
end
