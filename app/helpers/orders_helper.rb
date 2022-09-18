module OrdersHelper
    def cart_list
        if session[:user_id].nil?
            @cart = Cart.where(id_number: session[:guest_id]).where(del_flg: false)
            @user = User.find(2)
            if params[:email].present?
                @user.email = params[:email]
                @user.tel = params[:tel]
            else
                @user.email = nil
                @user.tel = nil
            end
        else
            @cart = Cart.where(id_number: session[:user_id]).where(del_flg: false)
            @user = User.find(session[:user_id])
            if params[:email].present?
                @user.email = params[:email]
                @user.tel = params[:tel]
            end
         end
    end
    #メニュー合計
    def cart_list_price
        @total_price = 0
        @cart.each do |cart|
            @total_price += cart.menu.price
        end
    end
end
