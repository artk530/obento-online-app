class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :name_kana
      t.string :email
      t.string :password_digest
      t.integer :post_code
      t.string :prefecture
      t.string :city_address
      t.string :address
      t.integer :tel
      t.boolean :admin, default: false, null: false
      t.boolean :del_flg, default: false, null: false

      t.timestamps
    end
  end
end
