class Admin::CategoriesController < ApplicationController
  before_action :auth_admin
  layout "admin"
  def index
    if params[:id].blank?
      @categories = Category.roots.page(params[:page] || 1).per_page(params[:per_page] || 5).order(id: "desc")
    else
      @category = Category.find(params[:id])
      @categories = @category.children.page(params[:page] || 1).per_page(params[:per_page] || 5).order(id: "desc")
    end
  end

  def new
    @category = Category.new
  end

  def create
    if !params[:category][:ancestry].blank?
      @category = Category.new(params.require(:category).
        permit(:type_name, :weight, :ancestry))
    else
      @category = Category.new(params.require(:category).
        permit(:type_name, :weight))
    end
    respond_to do |format|
      if @category.save
        flash[:notice] = "保存成功"
        format.html { redirect_to admin_categories_path }
        format.json { render :show, status: :created, location: @user }
      else
        flash[:notice] = "保存失败"
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if params[:category][:ancestry].blank?
      data = params.require(:category).
        permit(:type_name, :weight)
    else
      data = params.require(:category).
        permit(:type_name, :weight, :ancestry)
    end
    if @category.update(data)
      flash[:notice] = "修改成功"
      redirect_to admin_categories_path
    else
      flash[:notice] = "修改失败"
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy!
      flash[:notice] = "删除成功"
      redirect_to admin_categories_path
    else
      flash[:notice] = "删除失败"
      redirect_to :back
    end
  end


end
