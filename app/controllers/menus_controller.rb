class MenusController < ApplicationController
  def index
    @menus = Menu.all
  end

  def show
    @menu = current_menu
    @products = get_product

    #アレルギー名称 材料名称 取得
    @allergy = []
    @ing_name = []
    @products.each do |product|
      if product.ingredient.allergy_name == "無し"
        @ing_name.push(product.ingredient.name)
      else
        @allergy.push(product.ingredient.allergy_name)
        @ing_name.push(product.ingredient.name)
      end
    end
    if @allergy.blank?
      @allergy.push("ありません")
    end
  end

  def new
    @menu = Menu.new
    @ingredients = current_ing
  end

  def create
    @menu = Menu.new(menu_params)
      if params[:menu][:image].present?
        if @menu.save
          @menuid = Menu.find_by(name: params[:menu][:name])
          params[:menu][:ingredient].each do |ingredient|
            product = Product.new
            product.ingredient_id = ingredient
            product.menu_id = @menuid.id
            product.save
          end
          redirect_to root_path
        else
          render :new 
        end
      else
        flash.now[:alert] = "画像を登録してください"
        render :new
      end
  end

  def edit
    @menu = current_menu
    @ingredients = current_ing
    @products = get_product

    #材料名称 取得
    @ing_name = []
      @products.each do |product|
        @ing_name.push(product.ingredient.name)
      end
  end

  def update
    @menu = current_menu

    #選択した材料からid取得
    ing_id = []
    params[:menu][:ingredient].each do |ingredient|
      ingredients = Ingredient.find_by(id: ingredient)
      ing_id.push(ingredients.id)
    end
    
    ActiveRecord::Base.transaction do
      #対象メニューのproduct情報を一度解除する(del_flg=true)
      product_menu = Product.where(menu_id: params[:id])
      product_menu.each do |del|
        if del.update(del_flg: true)
        else
          raise "error"
          flash.now[:alert] = "更新できませんでした。DBの確認をしてください。product_del_flg"
          render :edit
        end
      end
      #productModelにすでにレコードがあるか判定
      ing_id.each do |i|
        product = Product.where(menu_id: params[:id]).where(ingredient_id: i)
        if product.blank?
          if Product.create({ menu_id: params[:id], ingredient_id: i, del_flg: false })
          else
            raise "error"
            flash.now[:alert] = "更新できませんでした。DBの確認をしてください。product_create"
            render :edit
          end
        else
          if product.update(del_flg: false)
          else
            raise "error"
            flash.now[:alert] = "更新できませんでした。DBの確認をしてください。product_update_del_flg"
            render :edit
          end
        end
      end
      if @menu.update(menu_params)
        flash[:notice] = "更新しました。"
        redirect_to menu_edit_path 
      else
        raise "error"
        flash.now[:alert] = "更新できませんでした。更新内容を確認してください。"
        render :edit
    end

    end
  end

  private
  def menu_params
    params.require(:menu).permit(:name, :price, :image)
  end

  def Product_params
    params.require(:product).permit(:menu_id, :ingredient_id, :del_flg)
  end
end
