class Menu < ApplicationRecord
    has_many :carts
    has_many :products
    has_many :purchasehistries

    #has_one_attached :image
    mount_uploader :image, ImageUploader

    validates :name, presence: true
    validates :price, presence: true
    validates_length_of :description, maximum: 300
end
