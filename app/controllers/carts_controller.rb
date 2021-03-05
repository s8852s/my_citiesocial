class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def destroy
    session[:my_cart] = nil
    redirect_to root_path, notice: '購物車已清空'
  end
end
