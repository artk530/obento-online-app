class OrderMailMailer < ApplicationMailer

    def order_mail(email)
        @email = email
        mail(to: @email, subject: "ご注文ありがとうございます")
    end

end
