module IngredientsHelper

        #削除されていない全ての材料情報を取得
        def ing_all
            Ingredient.where(del_flg: false)
        end
        
        #商品と材料の紐づけが有効なものを取得  
        def get_product
          Product.where(del_flg: false).where(menu_id: params[:id]).order(ingredient_id: :DESC)
        end

        def current_ing
          Ingredient.find(params[:id])
        end
end
