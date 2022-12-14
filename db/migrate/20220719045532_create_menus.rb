class CreateMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      t.string :name
      t.integer :price
      t.string :image
      t.boolean :del_flg, default: false, null: false

      t.timestamps
    end
  end
end
