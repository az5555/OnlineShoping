class Admin::ProductsController < ApplicationController
  layout "admin"
  before_action :auth_user


  # GET /products or /products.json
  def index
    @products = Product.all.page(params[:page] || 1).per_page(params[:per_page] || 6).order(id: "desc")
  end


  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit.html.erb
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
    @product.created_at = Time.now

    respond_to do |format|
      if @product.save
        flash[:notice] = "商品创建成功"
        format.html { redirect_to admin_products_path, notice: "创建成功" }
        format.json { render :show, status: :created, location: @product }
      else
        flash[:notice] = "商品创建失败"
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    @product = Product.find(params[:id])
    respond_to do |format|
      if @product.update(product_params)
        flash[:notice] = "商品修改成功"
        format.html { redirect_to admin_products_path, notice: "商品信息成功修改" }
        format.json { render :show, status: :ok, location: @product }
      else
        flash[:notice] = "商品修改失败"
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product = Product.find(params[:id])
    if @product.destroy!
      flash[:notice] = "删除成功"
      redirect_to admin_products_path
    else
      flash[:notice] = "删除失败"
      redirect_to :back
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:name, :category_id, :count, :price, :price_before, :description, :status, :image, :weight)
  end
end
