class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?, :user_admin_in?, :user_delivery_in?

  def current_user
    @current_user ||= User.find(session[:user]) if session[:user]
  end

  def user_signed_in?
    !current_user.nil?
  end

  def user_admin_in?
    user_signed_in? && !current_user.role.nil? && current_user.role == "admin"
  end

  def user_delivery_in?
    user_signed_in? && !current_user.role.nil? && current_user.role == "delivery"
  end


  protected

  def auth_user
    unless user_signed_in?
      flash[:notice] = "请登入"
      redirect_to new_session_path
      return
    end
  end

  def auth_admin
    unless user_signed_in?
      flash[:notice] = "请登入"
      redirect_to new_session_path
      return
    end

    unless user_admin_in?
      flash[:notice] = "非管理员请勿进入后台"
      redirect_to root_path
      return
    end
  end

  def auth_delivery
    unless user_signed_in?
      flash[:notice] = "请登入"
      redirect_to new_session_path
      return
    end

    unless user_delivery_in? || user_admin_in?
      flash[:notice] = "非快递小哥请勿进入接单页面"
      redirect_to root_path
      return
    end
  end
end
