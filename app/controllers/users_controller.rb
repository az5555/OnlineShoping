class UsersController < ApplicationController

  before_action :auth_user, only: %i[ update edit show upload_image]

  # GET /users or /users.json

  # GET /users/1 or /users/1.json
  def show
    @user = current_user
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit.html.erb
  def edit
    @user = current_user
  end

  # POST /users or /users.json
  def create
    @user = User.new(params.require(:user).permit(:username, :email, :password, :password_confirmation, :address))
    respond_to do |format|
      if @user.save
        flash[:notice] = "注册成功, 请登入"
        format.html { redirect_to new_session_path }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    @user = User.find(params[:id])
    if !@user.password.eql?params[:user][:password_old]
      flash[:notice] =  "密码错误"
      redirect_back fallback_location: root_path
    else
      if params[:user][:admin_pass].eql?"21373399"
        params[:user][:role] = "admin"
      end
      if params[:user][:password].blank?
        params[:user][:password] = @user.password
        params[:user][:password_confirmation] = @user.password
      end
      data = params.require(:user).permit(:username, :password, :telephone, :role, :password_confirmation, :address)
      if @user.update(data)
        flash[:notice] = "修改成功"
        redirect_to userCenter_path
      else
        flash[:notice] = @user.errors
        redirect_back fallback_location: root_path
      end
    end
  end

  def upload_image
    @user = current_user
    if params[:image].nil?
      flash[:notice] = '请上传头像'
      redirect_to userCenter_path
      return
    end
    @user.password_confirmation = @user.password
    if @user.image.attach(params[:image])
      flash[:notice] = '修改成功'
    else
      flash[:notice] = '修改失败'
    end
    redirect_to userCenter_path
  end


  private
    # Use callbacks to share common setup or constraints between actions.

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :password, :email, :telephone, :role, :address)
    end
end
