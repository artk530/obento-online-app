class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.integer :menu_id
      t.integer :ingredient_id
      t.boolean :del_flg, default: false, null: false

      t.timestamps
    end
  end
end
