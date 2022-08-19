class Menu < ApplicationRecord
    has_many :carts
    has_many :products
    has_many :purchase_histries

    has_one_attached :image

    validates :name, presence: true
    validates :price, presence: true
end
