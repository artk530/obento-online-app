class Ingredient < ApplicationRecord
    has_many :products

    validates :name, presence: true
    validates :allergy_name, presence: true

end
