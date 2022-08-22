class DeliveryMailMailer < ApplicationMailer

    def delivery_mail(email,cart,user,receive,address,tel,total_price)
        @email = email
        @cart = cart
        @user = user
        @receive = receive
        @address = address
        @tel = tel
        @total_price = total_price
        mail(to: @email, subject: "ご注文ありがとうございます")
    end
end
