class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    user = User.new(user_params)
    if user.save!
      log_in user
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
       redirect_to root_path
    else
      render :edit
    end
  end

  private
  #項目追加する
  def user_params
    params.require(:user).permit(:name, :name_kana, :email, :password, :password_confirmation, :address, :tel)
  end
end
