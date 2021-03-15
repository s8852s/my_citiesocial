#  PORO = Plain Old Ruby Object 純Ruby類別
class Cart
  attr_reader :items
  def initialize(items = [])
    @items = items
  end

  def serialize
    # items = [
    #   { "sku_id" => 1, "quantity" => 3 },
    #   { "sku_id" => 2, "quantity" => 2 },
    # ]

    items = @items.map { |item| { "sku_id" => item.sku_id,
                                  "quantity" => item.quantity } }

    { "items" => items }
  end

  def self.from_hash(hash = nil)
    # {
    #   "items" => [
    #     {"sku_id" => 1, "quantity" => 3},
    #     {"sku_id" => 2, "quantity" => 2},
    #   ]
    # }

    if hash && hash["items"]
      items = hash["items"].map { | item |
        CartItem.new(item["sku_id"], item["quantity"])
      }
      Cart.new(items)
    else
      Cart.new
    end
  end

  def add_sku(sku_id, quantity = 1)
    found = @items.find { |item| item.sku_id == sku_id }
    if found
      found.increment!
    else
      @items << CartItem.new(sku_id, quantity = 1)
    end
  end

  def empty?
    @items.empty? #@items是陣列，陣列本來就有empty?方法可用
  end

  def total_price
    
    # @items.reduce(0) { |sum, item| sum + item.total_price }
    # total = 0
    # @items.each do |item|
    #   total += item.total_price
    # end
    # total
    total = @items.sum { |item| item.total_price }
    if Date.today.month == 12 && Date.today.day == 25
      total = total * 0.9
    end
    total
  end
end