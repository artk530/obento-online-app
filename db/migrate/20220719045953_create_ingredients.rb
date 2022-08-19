class CreateIngredients < ActiveRecord::Migration[5.2]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.integer :menu_id
      t.string :allergy_name
      t.boolean :del_flg, default: false, null: false

      t.timestamps
    end
  end
end
