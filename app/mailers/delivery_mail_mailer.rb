class DeliveryMailMailer < ApplicationMailer

    def delivery_mail(email,cart,user,receive,post_code,address,tel,total_price,ordernumber)
        @email = email
        @cart = cart
        @user = user
        @receive = receive
        @post_code = post_code
        @address = address
        @tel = tel
        @total_price = total_price
        @ordernumber = ordernumber
        mail(to: @email, subject: "ご注文ありがとうございます")
    end
end
