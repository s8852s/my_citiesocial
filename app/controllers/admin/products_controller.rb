class Admin::ProductsController < Admin::BaseController
  before_action :find_product, only: [:edit, :update, :destroy]

  def index
    @products = Product.all.includes(:vendor)
  end

  def show
    @product = Product.find(params[:id])
  end
  
  def new
    @product = Product.new
    @product.skus.build
    # @product.skus.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path, notice: "成功新增商品"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to edit_admin_product_path(@product), notice: "商品已更新"
    else
      render :edit
    end
  end

  def destroy
    @product.destroy if @product
    redirect_to admin_products_path, notice: "商品已刪除"
  end

  private
  def product_params
    params.require(:product).permit(:name, 
                                    :vendor_id, 
                                    :list_price, 
                                    :sell_price, 
                                    :on_sell, 
                                    :cover_image,
                                    :category_id,
                                    :description,
                                    skus_attributes: [
                                      :id, :spec, :quantity, :_destroy
                                    ])
  end

  def find_product
    @product = Product.friendly.find(params[:id])
  end

end
