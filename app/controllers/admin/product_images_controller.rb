class Admin::ProductImagesController < ApplicationController
  before_action :auth_user
  layout "admin"

  def new
    @product = ProductImage.new
  end

  def index
    @product = Product.find(params[:product_id])
    @product_images = @product.product_images
  end

  def create
    @product = Product.find(params[:product_id])
    unless params[:images].nil?
      params[:images].each do |image_product|
        @product.product_images << ProductImage.new(image: image_product)
      end
    end

    redirect_back fallback_location: root_path
  end

  def destroy
    @product = Product.find(params[:product_id])
    @product_image = @product.product_images.find(params[:product_image_id])
    if @product_image.destroy!
      flash[:notice] = "删除成功"
    else
      flash[:notice] = "删除失败"
    end
    redirect_back fallback_location: root_path
  end

  def update
    @product = Product.find(params[:product_id])
    @product_image = @product.product_images.find(params[:product_image_id])
    @product_image = params[:product_id]
    if @product_image.save
      flash[:notice] = "修改成功"
    else
      flash[:notice] = "修改失败"
    end
    redirect_back fallback_location: root_path
  end
end
