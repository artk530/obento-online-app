class IngredientsController < ApplicationController
  def index
    @ingredients = Ingredient.where(del_flg: false)
  end

  def new
    @ingredient = Ingredient.new
  end

  def create
    @ingredient = Ingredient.new(ing_params)
    if @ingredient.save
      redirect_to ing_index_path
    else
      render :new
    end
  end

  def edit
    @ingredient = Ingredient.find(params[:id])
  end

  def update
    @ingredient = Ingredient.find(params[:id])
    if @ingredient.update(ing_params)
      redirect_to ing_index_path
    else
      render :edit
    end
  end

  def destroy
    @ingredient = Ingredient.find(params[:id])
    if @ingredient.update(del_flg: true)
      redirect_to ing_index_path
    else
      render :index
    end
  end
  

  private
  def ing_params
    params.require(:ingredient).permit(:name,:allergy_name)
  end
  
end
