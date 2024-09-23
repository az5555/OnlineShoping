class RequestsController < ApplicationController
  before_action :auth_user
  def create
    list = Request.find_by(user_id: current_user.id)
    if list.nil?
      @request = Request.new
      @request.user_id = current_user.id
      @request.username = current_user.username
      @request.save!
      flash[:notice] = '已提交申请，请耐心等待'
      redirect_to userCenter_path
    else
      flash[:notice] = '您已经提交申请，请勿重复提交'
      redirect_to userCenter_path
    end
  end
end
