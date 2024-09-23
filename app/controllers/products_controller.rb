class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show ]

  # GET /products or /products.json
  def index
    @products = Product.all.page(params[:page] || 1).per_page(params[:per_page] || 6).order(weight: "asc")
  end

  # GET /products/1 or /products/1.json
  def show
    @categories = Category.grouped_data
    @product = Product.find(params[:id])
    if @product.nil?
      flash[:notice] = '商品惨遭删除'
      redirect_to root_path
    end
  end

  def search
    @products = Product.where("name like ? or description like ?", "%" + params[:w] + "%", "%" + params[:w] + "%")

    unless params[:category_id].blank?
      @products = @products.where(category_id: params[:category_id])
    end
    @products = @products.first(4)
    @categories = Category.grouped_data
    render "products/search"
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit!
    end
end
