class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :find_category, unless: :backend?
  helper_method :current_cart
  # 讓view也可以使用這個方法

  private
  def record_not_found
    render file: "#{Rails.root}/public/404.html", # rails專案的根目錄
           layout: false,
           status: 404
  end

  def backend?
    controller_path.split('/').first == 'Admin'
  end

  def find_category
    @categories = Category.order(position: :asc)
  end

  def current_cart
    @my_cart ||= Cart.from_hash(session[:my_cart])
  end
end
