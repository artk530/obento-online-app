class OrdersController < ApplicationController

  def new
   cart_list
   cart_list_price
  end

  def check
    cart_list
    cart_list_price
    @user.address = params[:address]

    @check = Check.new(email: params[:email])
    if @check.valid?
    else
      flash.now[:alert] = "メールアドレスが正しく入力されていません"
      render :new
    end
  
    #配達希望の場合の送料を追加
    if params[:receive] == "delivery"
      @total_price += 300
    end

      case params[:receive]
      when "shop"
        session[:receive] = "店舗で受け取る"
      when "delivery"
        session[:receive] = "自宅まで配達を希望　料金+300円"
      else
        session[:receive] = "お弁当の受け取り方法が選択されていません"
      end
   
    session[:email] = params[:email]
    session[:tel] = params[:tel]
    session[:post_code] = params[:post_code]
    session[:address] = params[:address]
  end

  def create
   cart_list
   cart_list_price
   if session[:receive] == "自宅まで配達を希望　料金+300円"
    @total_price += 300
   end

   ActiveRecord::Base.transaction do 
    #今回の注文番号の作成
    ordernumber = OrderNumber.find(1)
    @number = ordernumber.number += 1
    if ordernumber.update!(number: @number)
    else
    end
     #注文確定したメニューをPurchaseHistrieにレコードを追加する
     @cart.each do |cart|
       if PurchaseHistrie.create!(menu_id: cart.menu_id, user_id: @user.id)
       else
       end
     end
     #カートに追加していたメニューのdel_flgをtrueに変更する
     @cart.each do |cart|
       if cart.update!(del_flg: true)
       end
     end
   rescue => e
    flash.now[:alert] =  "注文確定処理でエラーが発生しました。注文が完了していないため、お手数ですが店舗までご連絡をお願いいたします。"
    render :check
   end
    #お弁当の受け取り方法によって送信するメールを判別
    case session[:receive] 
    when "店舗で受け取る"
      if OrderMailMailer.order_mail(session[:email],@cart,@user,session[:receive],session[:tel],@total_price,@number).deliver
        redirect_to order_fin_path
      else
        flash.now[:alert] = "注文確定処理でエラーが発生しました。注文が完了していないため、お手数ですが店舗までご連絡をお願いいたします。"
        redirect_to root_path
      end
    when "自宅まで配達を希望　料金+300円"
      if DeliveryMailMailer.delivery_mail(session[:email],@cart,@user,session[:receive],session[:post_code],session[:address],session[:tel],@total_price,@number).deliver
        redirect_to order_fin_path
        else
        flash.now[:alert] = "注文確定処理でエラーが発生しました。注文が完了していないため、お手数ですが店舗までご連絡をお願いいたします。"
        redirect_to root_path
      end
    end
    session[:email] = nil
    session[:tel] = nil
    session[:post_code] = nil
    session[:address] = nil
    session[:receive] = nil
  end

end
