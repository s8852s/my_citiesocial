class Api::V1::UtilsController < ApplicationController
  def subscribe
    email = params['subscribe']['email']
    sub = Subscribe.new(email: email)
    if sub.save
      render json: { status: 'ok', email: email}
    else
      render json: { status: 'duplicated', email: email}
    end
  end

  def cart
    product = Product.friendly.find(params[:id])

    if product
      cart = Cart.from_hash(session[:my_cart])
      cart.add_item(product.code)
      session[:my_cart] = cart.serialize
      render json: { status: "OK", items: cart.items.count }
    end
    
  end
end
