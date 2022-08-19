module MenusHelper
    def current_menu
        return Menu.find_by(id: params[:id])
    end
end
