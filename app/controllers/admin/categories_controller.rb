class Admin::CategoriesController < Admin::BaseController
  def index
  end

  def new
    @category = Category.new
  end
end
