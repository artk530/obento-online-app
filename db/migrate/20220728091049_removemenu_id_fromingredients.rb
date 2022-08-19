class RemovemenuIdFromingredients < ActiveRecord::Migration[5.2]
  def change
    remove_column :ingredients, :menu_id, :integer
  end
end
