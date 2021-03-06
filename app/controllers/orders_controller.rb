class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.order(id: :desc)
  end

  def create
    @order = current_user.orders.build(order_params)

    # debugger

    current_cart.items.each do |item|
      @order.order_items.build(sku_id: item.sku, quantity: item.quantity)
    end

    if @order.save
      resp = Faraday.post("#{ENV['line_pay_endpoint']}/v2/payments/request") do |req|
        req.headers['Content-Type'] = application/json
        req.headers['X-LINE-ChannelId'] = ENV['line_pay_channel_id']
        req.headers['X-LINE-ChannelSecret'] = ENV['line_pay_channel_secret']
        req.body = {
          productName: '五百倍大平台',
          amount: current_cart.total_price.to_i,
          currency: "TWD",
          confirmUrl: "http://localhost:3000/orders/confirm",
          orderId: @order.num
        }.to_json
      end

      result = JSON.parse(resp.body)

      if result["returnCode"] == "0000"
        payment_url = result["info"]["paymentUrl"]["web"]
        redirect_to payment_url
      else
        flash[:notice] = "付款發生錯誤"
        render "carts/checkout"
      end

      # redirect_to root_path, notice: "OK"
    end
  end

  def confirm
    resp = Faraday.post("#{ENV['line_pay_endpoint']}/v2/payments/#{params[:transactionId]}/confirm") do |req|
      req.headers['Content-Type'] = application/json
      req.headers['X-LINE-ChannelId'] = ENV['line_pay_channel_id']
      req.headers['X-LINE-ChannelSecret'] = ENV['line_pay_channel_secret']
      req.body = {
        amount: current_cart.total_price.to_i,
        currency: "TWD"
      }.to_json
    end
    
    result = JSON.parse(resp.body)
    if result["returnCode"] == "0000"
      order_id = result["info"]["orderId"]
      transaction_id = result["info"]["transactionId"]

      order = current_user.orders.find_by(num: order_id)
      order.pay!(transaction_id: transaction_id)

      session[:my_cart] = nil

      redirect_to root_path, notice: "付款已完成"
    else
      redirect_to root_path, notice: "付款發生錯誤"
    end

    render html: id
  end

  def cancel
    @order - current_user.orders.find(params[:id])
    if @order.paid?
      resp = Faraday.post("#{ENV['line_pay_endpoint']}/v2/payments/#{@order.transaction_id}/refund") do |req|
        req.headers['Content-Type'] = application/json
        req.headers['X-LINE-ChannelId'] = ENV['line_pay_channel_id']
        req.headers['X-LINE-ChannelSecret'] = ENV['line_pay_channel_secret']
      end

      result = JSON.parse(resp.body)

      if result["returnCode"] == "0000"
        @order.cancel!
        redirect_to orders_path, notice: "訂單 #{@order.num} 已取消，並完成退款!"
      else
        redirect_to orders_path, notice: "退款發生錯誤"
      end
    else
      @order.cancel!
      redirect_to orders_path, notice: "訂單 #{@order.num} 已取消!"
    end
  end

  private
  def order_params
    params.require(:order).permit(:recipient, :tel, :address, :note)
  end
end
