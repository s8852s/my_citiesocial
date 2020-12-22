class ProductsController < ApplicationController

  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])
  end
  
  def new
    @product = Product.new
  end

  def create
    @product = 
  end

  private
  def product_params
    params.require(:prduct).permit(:name, :list_price, :sell_price, :on_sell)
  end
end
