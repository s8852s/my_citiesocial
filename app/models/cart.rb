#  PORO = Plain Old Ruby Object 純Ruby類別
class Cart
  attr_reader :items
  def initialize
    @items = []
  end
  def add_item(product_id, quantity = 1)
    found = @items.find { |item| item.product_id == product_id }
    if found
      found.increment!
    else
      @items << CartItem.new(product_id, quantity = 1)
    end
  end

  def empty?
    @items.empty? #@items是陣列，陣列本來就有empty?方法可用
  end

  def total_price
    @items.reduce(0) { |sum, item| sum + item.total_price }
    # total = 0
    # @items.each do |item|
    #   total += item.total_price
    # end
    # total
  end
end