class SessionsController < ApplicationController
  def new
    #sda
  end

  def create
    user = User.find_by email: params[:email]
    if user
      if user.status == 0
        flash[:notice] = "该账号已被封禁"
        redirect_to root_path
      elsif user.password.eql?params[:password]
        flash[:notice] = "登入成功"
        session[:user] = user.id
        redirect_to root_path
      else
        flash[:notice] = "密码错误"
        redirect_to sessions_path
      end
    else
      flash[:notice] = "邮箱不存在"
      redirect_to new_session_path
    end
  end


  def destroy
    flash[:notice] = "退出成功"
    session[:user] = nil
    redirect_to root_path
  end
end
