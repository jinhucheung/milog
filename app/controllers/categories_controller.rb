class CategoriesController < ApplicationController
  before_action :check_signed_in, only: [:create, :destroy]
  before_action :check_activated, only: [:create, :destroy]

  def create
    category = current_user.categories.find_by category_params
    if category
      render json: { error: category.name + "已存在" }, status: 400
    else
      category = current_user.categories.create category_params
      if category.valid?
        render json: { name: category.name}, status: 200        
      else
        render json: { error: category.errors.full_messages[0] }, status: 400
      end
    end
  end

  def destroy
  end

  def index

  end

  private
    def category_params
      params.require(:category).permit(:name)
    end
end