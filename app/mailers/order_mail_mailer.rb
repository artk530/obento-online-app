class OrderMailMailer < ApplicationMailer

    def order_mail(email,cart,user,receive,address,tel,total_price,ordernumber)
        @email = email
        @cart = cart
        @user = user
        @receive = receive
        @address = address
        @tel = tel
        @total_price = total_price
        @ordernumber = ordernumber
        mail(to: @email, subject: "ご注文ありがとうございます")
    end

end
