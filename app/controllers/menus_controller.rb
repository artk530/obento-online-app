class MenusController < ApplicationController
  def index
    @menus = Menu.where(del_flg: false)
    if session[:user_id] == 1
      @admin_user = true
    else
      @admin_user = false
    end
    menu_in_top3 = []
    @nocount = 1
    count = 0
    top3 = PurchaseHistrie.where(created_at: Time.current.prev_month..Time.current).group(:menu_id).order('count_all DESC').count
    top3.each do |menu_id, sum_count|
      if count == 3
        break
      else
        del_menu = Menu.find(menu_id)
        if  del_menu.del_flg == true
        else
          menu_in_top3.push(Menu.find(menu_id))
          count += 1
        end
        
      end
    end
    @no1 = menu_in_top3[0]
    @no2 = menu_in_top3[1]
    @no3 = menu_in_top3[2]

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
    @ingredients = ing_all
  end

  def create
    @menu = Menu.new(menu_params)
    @ingredients = ing_all
    ActiveRecord::Base.transaction do
      if params[:menu][:image].present?
        if params[:menu][:ingredient].present?
          if @menu.save!
            @menuid = Menu.find_by(name: params[:menu][:name])
            params[:menu][:ingredient].each do |ingredient|
              #追加したメニューと材料情報をproductテーブルに格納
              product = Product.new
              product.ingredient_id = ingredient
              product.menu_id = @menuid.id
              product.save!
            end
            flash[:notice] = "新規メニューを登録しました"
            redirect_to root_path
          else
            render :new 
          end
        else
          flash.now[:alert] = "使用している材料を1つ以上選択してください"
          render :new
        end
      else
        flash.now[:alert] = "画像を登録してください"
        render :new
      end
    end
    rescue => e
    flash[:alert] =  "メニューの登録に失敗しました。登録内容を確認し、再度処理を実施してください。"
    redirect_to menu_new_path
  end

  def edit
    @menu = current_menu
    @ingredients = ing_all
    @products = get_product

    #材料名称 取得
    @ing_name = []
      @products.each do |product|
        @ing_name.push(product.ingredient.name)
      end
  end

  def update
    @menu = current_menu
    @ingredients = ing_all
    @products = get_product

     #材料名称 取得
     @ing_name = []
     @products.each do |product|
       @ing_name.push(product.ingredient.name)
     end
    
    ActiveRecord::Base.transaction do
      #材料が選択されているか確認
      if params[:menu][:ingredient].blank?
      else
        #編集中メニューのproductテーブルの紐付けを一度解除(del_flg⇒true)
        product_menu = Product.where(menu_id: params[:id])
        product_menu.each do |pmenu|
          if pmenu.update!(del_flg: true)
          end
        end
        #編集で選択された材料毎にproductテーブルの作成/紐付け(def_flg⇒false)
        params[:menu][:ingredient].each do |ing_id| 
          create_product = Product.where(menu_id: params[:id], ingredient_id: ing_id)
          if create_product.blank?
            if Product.create!({ menu_id: params[:id], ingredient_id: ing_id, del_flg: false })
            end
          else
            if create_product.update(del_flg: false)
            end
          end
        end
      end

      if params[:menu][:ingredient].blank?
          flash[:alert] = "使用している材料を選択してください"
          redirect_to menu_edit_path
      else
          if @menu.update!(menu_params)
            flash[:notice] = "メニュー情報を更新しました。"
            redirect_to menu_edit_path 
          else
            render :edit
          end
      end
    end 
    rescue => e
      flash[:alert] =  "メニューの更新に失敗しました。登録内容を確認し、再度処理を実施してください。"
      redirect_to menu_edit_path 
  end

  def destroy
    @menu = current_menu
    if @menu.update(del_flg: true)
      flash[:notice] = "削除しました"
      redirect_to root_path
    else
      flash.now[:alert] = "メニューの削除に失敗しました。もう一度処理を実施してください"
      render :index
    end
  end

  private
  def menu_params
    params.require(:menu).permit(:name, :price, :image, :description)
  end
end
