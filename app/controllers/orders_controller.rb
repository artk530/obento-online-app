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
   #注文確定した商品をPurchaseHistrieにレコードを追加する
   @cart.each do |cart|
     if PurchaseHistrie.create(menu_id: cart.menu_id, user_id: @user.id)
     else
       flash[:alert] = "注文確定処理でエラーが発生しました。注文が完了していないため、お手数ですが店舗までご連絡をお願いいたします。"
       redirect_to root_path
     end
   end
   
   @address = session[:address]
   @tel = session[:tel]
   @receive = session[:receive]
   @email = session[:email]
   case session[:receive] 
   when "店舗で受け取る"
    if OrderMailMailer.order_mail(@email,@cart,@user,@receive,@address,@tel,@total_price).deliver
    else
      flash[:alert] = "注文確定処理でエラーが発生しました。注文が完了していないため、お手数ですが店舗までご連絡をお願いいたします。"
      redirect_to root_path
    end
   when "自宅まで配送を希望　料金+300円"
    DeliveryMailMailer.delivery_mail(@email,@cart,@user,@receive,@address,@tel,@total_price).deliver
    flash[:alert] = "注文確定処理でエラーが発生しました。注文が完了していないため、お手数ですが店舗までご連絡をお願いいたします。"
    redirect_to root_path
   end
   redirect_to order_fin_path
  end

end
