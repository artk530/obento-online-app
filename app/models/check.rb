class Check
    include ActiveModel::Model
   
    attr_accessor :email

   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
   validates :email, format: { with: VALID_EMAIL_REGEX }
  end