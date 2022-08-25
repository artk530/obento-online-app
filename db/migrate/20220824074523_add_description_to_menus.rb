class AddDescriptionToMenus < ActiveRecord::Migration[5.2]
  def change
    add_column :menus, :description, :string
  end
end
