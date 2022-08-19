class RemoveingredientIdFrommenus < ActiveRecord::Migration[5.2]
  def change
    remove_column :menus, :ingredient_id, :integer
  end
end
