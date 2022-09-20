class UsersController < ApplicationController

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:notice] = "会員登録が正常に完了しました　また作成した会員情報でログインしました"
      redirect_to root_path
    else
      flash.now[:alert] = "会員登録に失敗しました　もう一度登録処理を実施してください"
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.id == 1 || @user.id == 2
      flash[:alert] = "本ユーザーを変更することはできません"
      redirect_to root_path
    else
      if @user.update(user_params)
        flash[:notice] = "会員情報を更新しました"
        redirect_to user_edit_path(params[:id])
     else
       flash.now[:alert] = "会員情報の更新に失敗しました　もう一度更新処理を実施してください"
       render :edit
     end
    end  
    
  end

  def destroy
    @user = User.find(params[:id])
    if @user.id == 1 || @user.id == 2
      flash[:alert] = "本ユーザーを削除することはできません"
      redirect_to root_path
    else
      if @user.delete
          log_out if logged_in?
          flash[:notice] = "退会処理が正常に完了しました　ご利用いただきありがとうございました"
          redirect_to root_path
        else
          flash[:alert] = "退会処理に失敗しました　もう一度処理を実施してください"
          redirect_to root_path
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :name_kana, :email, :password, :password_confirmation, :post_code, :address, :tel)
  end
end
