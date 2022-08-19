class ApplicationMailer < ActionMailer::Base
  default from: "<obentoshop123@gmail.com>",
          bcc: "<obentoshop123@gmail.com>",
          reply_to: "<obentoshop123@gmail.com>"
  layout 'mailer'
end
