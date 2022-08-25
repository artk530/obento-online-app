class OrdersController < ApplicationController

  def new
   cart_list
   cart_list_price
  end

  def check
    cart_list
    cart_list_price
    #配送希望の場合の送料を追加
    if params[:receive] == "delivery"
      @total_price += 300
    end

      case params[:receive]
      when "shop"
        session[:receive] = "店舗で受け取る"
      when "delivery"
        session[:receive] = "自宅まで配送を希望　料金+300円"
      else
        session[:receive] = "お弁当の受け取り方法が選択されていません"
      end
   
    session[:email] = params[:email]
    session[:tel] = params[:tel]
    session[:address] = params[:address]
  end

  def create
   cart_list
   cart_list_price
   if session[:receive] == "自宅まで配送を希望　料金+300円"
    @total_price += 300
   end

   #今回の注文番号の作成
   ordernumber = OrderNumber.find(1)
   number = ordernumber.number += 1
   if ordernumber.update(number: number)
    flash[:alert] = "注文確定処理でエラーが発生しました。注文が完了していないため、お手数ですが店舗までご連絡をお願いいたします。"
    redirect_to root_path
   else
   end

   
   #注文確定した商品をPurchaseHistrieにレコードを追加する
   @cart.each do |cart|
     if PurchaseHistrie.create(menu_id: cart.menu_id, user_id: @user.id)
     else
       flash[:alert] = "注文確定処理でエラーが発生しました。注文が完了していないため、お手数ですが店舗までご連絡をお願いいたします。"
       redirect_to root_path
     end
   end
   
   #お弁当の受け取り方法によって送信するメールを判別
   case session[:receive] 
   when "店舗で受け取る"
    if OrderMailMailer.order_mail(session[:email],@cart,@user,session[:receive],session[:address],session[:tel],@total_price,number).deliver
    else
      flash[:alert] = "注文確定処理でエラーが発生しました。注文が完了していないため、お手数ですが店舗までご連絡をお願いいたします。"
      redirect_to root_path
    end
   when "自宅まで配送を希望　料金+300円"
    DeliveryMailMailer.delivery_mail(session[:email],@cart,@user,session[:receive],session[:address],session[:tel],@total_price,number).deliver
    flash[:alert] = "注文確定処理でエラーが発生しました。注文が完了していないため、お手数ですが店舗までご連絡をお願いいたします。"
    redirect_to root_path
   end
   
   #終了ページを表示
   redirect_to order_fin_path
  end

end
