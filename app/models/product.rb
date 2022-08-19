class Product < ApplicationRecord
    belongs_to :menu
    belongs_to :ingredient
end
