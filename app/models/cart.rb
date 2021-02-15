#  PORO = Plain Old Ruby Object 純Ruby類別
class Cart
  def initialize
    @items = []
  end
  def add_item(product_id)
    @items << product_id
  end

  def empty?
    @items.empty? #@items是陣列，陣列本來就有empty?方法可用
  end
end