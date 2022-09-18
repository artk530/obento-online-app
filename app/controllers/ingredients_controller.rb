class IngredientsController < ApplicationController
  def index
    @ingredients = ing_all
  end

  def new
    @ingredient = Ingredient.new
  end

  def create
    @ingredient = Ingredient.new(ing_params)
    if @ingredient.save
      flash[:notice] =  "新規材料を登録しました。"
      redirect_to ing_index_path
    else
      render :new
    end
  end

  def edit
    @ingredient = current_ing
  end

  def update
    @ingredient = current_ing
    if @ingredient.update(ing_params)
      flash[:notice] =  "材料情報を更新しました。"
      redirect_to ing_index_path
    else
      render :edit
    end
  end

  def destroy
    ingredient = current_ing
    ActiveRecord::Base.transaction do
      #productテーブルで削除した材料が紐付けられていたら削除する
      product_list = Product.where(ingredient_id: params[:id])
      product_list.each do |product|
        product.update!(del_flg: true)
      end

      #削除した材料をingテーブルで削除する
      if ingredient.update!(del_flg: true)
        flash[:notice] =  "削除しました。"
        redirect_to ing_index_path
      else
        render :index
      end
    end
    rescue => e
    flash[:alert] =  "削除に失敗しました。再度処理を実施してください。"
    redirect_to ing_index_path
  end
  

  private
  def ing_params
    params.require(:ingredient).permit(:name,:allergy_name)
  end
  
end
