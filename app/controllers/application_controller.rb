class ApplicationController < ActionController::Base
    include MenusHelper
    include SessionsHelper
    include CartsHelper
    include OrdersHelper
    include IngredientsHelper
    add_flash_types :success, :info, :warning, :danger
end
