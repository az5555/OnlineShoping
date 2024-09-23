class CollectionsController < ApplicationController
  before_action :auth_user

  def index
    @collections = Collection.by_user_id(session[:user])
                                  .order(id: "desc")
  end

  def create
    list = Collection.find_by(user_id: session[:user], product_id: params[:product_id])
    if list.nil?
      @collection = Collection.new(user_id: session[:user], product_id: params[:product_id])
      if @collection.save
        flash[:notice] = "收藏成功"
      end
    else
      flash[:notice] = "已经在收藏夹中"
    end

    redirect_back fallback_location: root_path
  end


  def destroy
    @collections = Collection.find(params[:id])
    @collections.destroy if @collections
    flash[:notice] = "删除成功"
    redirect_to collections_path
  end
end
