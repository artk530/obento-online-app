class Menu < ApplicationRecord
    has_many :carts
    has_many :products
    has_many :purchasehistries

    has_one_attached :image

    validates :name, presence: true
    validates :price, presence: true
    validates :description, length: { maximum: 300 }
end
