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
   @email = session[:email]
   case session[:receive] 
   when "店舗で受け取る"
    p "----------------"
    p session[:receive]
    #OrderMailMailer.order_mail(@email).deliver
   when "自宅まで配送を希望　料金+300円"
    p "******************"
    OrderMailMailer.delivery_mail(@email).deliver
   end  
  end

end
