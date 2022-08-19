class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
      t.integer :menu_id
      t.integer :id_number
      t.boolean :del_flg, default: false, null: false

      t.timestamps
    end
  end
end
