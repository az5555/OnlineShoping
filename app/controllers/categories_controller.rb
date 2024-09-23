class CategoriesController < ApplicationController


  def show
    @categories = Category.grouped_data
    @category = Category.find(params[:id])
    @products = @category.products.on_sale.page(params[:page] || 1).per_page(params[:per_page] || 10).order(weight: "desc")
  end
end
