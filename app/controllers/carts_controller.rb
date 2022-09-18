class CartsController < ApplicationController
  def index
    @cart_nil_message = nil
    if session[:user_id].nil?
      @cart = Cart.where(id_number: session[:guest_id]).where(del_flg: false)
    else
      @cart = Cart.where(id_number: session[:user_id]).where(del_flg: false)
    end
    #金額算出
    @total_price = 0
    @cart.each do |cart|
      @total_price += cart.menu.price
    end

    if @cart.blank?
      @cart_nil_message = "お弁当が1つもカートに追加されていません"
      @next = render :index
    else
      @next = order_new_path
    end
  end

  def create
    create_id_number
    menu_id = params[:menu][:menu_id]
        
    #購入数毎に保存し、最後の保存時にメッセージを表示
    quantity = 0
    while quantity < params[:menu][:quantity].to_i do
      if quantity < (params[:menu][:quantity].to_i - 1)
          if Cart.create(menu_id: menu_id, id_number: @id_number)
          else
            flash.now[:alert] = "カートに追加できませんでした。お手数ですがもう一度操作を実施してください"
            redirect_to root_path
         end
      else
          if Cart.create(menu_id: menu_id, id_number: @id_number)
            flash[:notice] = "カートに追加しました。"
            redirect_to root_path
          else
            flash[:alert] = "カートに追加できませんでした。お手数ですがもう一度操作を実施してください"
            redirect_to root_path
          end
         end
         quantity += 1
      end
    end

  def update
    
    create_id_number
    menu_id = params[:menu][:menu_id]
        
    #購入数毎に保存し、最後の保存時にメッセージを表示
    quantity = 0
    while quantity < params[:menu][:quantity].to_i do
      if quantity < (params[:menu][:quantity].to_i - 1)
          if Cart.create(menu_id: menu_id, id_number: @id_number)
          else
            flash[:alert] = "カートに追加できませんでした。お手数ですがもう一度操作を実施してください"
            redirect_to menu_show_path(params[:menu][:menu_id])
         end
      else
          if Cart.create(menu_id: menu_id, id_number: @id_number)
            flash[:notice] = "カートに追加しました。"
            redirect_to menu_show_path(params[:menu][:menu_id])
          else
            flash[:alert] = "カートに追加できませんでした。お手数ですがもう一度操作を実施してください"
            redirect_to menu_show_path(params[:menu][:menu_id])
          end
         end
         quantity += 1
      end
    end

  def destroy
    cart = Cart.find_by(id: params[:cart][:cart_id])
    if cart.update(del_flg: true)
      redirect_to cart_list_path
    else
    end
  end
end
