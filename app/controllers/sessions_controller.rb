class SessionsController < ApplicationController
  def new
  end

  def create 
    user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
          log_in user
          params[:session][:remember_me] == '1' ?  remember(user) : forget(user)
          flash[:notice] = "ログインしました"
          redirect_to root_path
      else
        flash.now[:alert] = "入力されたアカウント情報が正しくありません"
        render :new
      end         
  end

  def admin_login
    user = User.find(1)
    log_in user
    flash[:notice] = "ログインしました"
    redirect_to root_path
  end

  def destroy
    cart_list
    #カートに追加していたメニューのdel_flgをtrueに変更する
    @cart.each do |cart|
      if cart.update!(del_flg: true)
      end
    end
    log_out if logged_in?
    flash.now[:notice] = "ログアウトしました"
    
    redirect_to root_path
  end
end
