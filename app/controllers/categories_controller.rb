class CategoriesController < ApplicationController
  before_action :check_signed_in, only: [:create, :destroy, :update]
  before_action :check_activated, only: [:create, :destroy, :update]
  before_action :limit_add_default_category, only: [:create]
  before_action :get_category, only: [:create, :destroy, :update]

  def create
    return render json: { status: 400, error: I18n.t("errors.category_has_existed", name: @category.name) }  if @category 
    @category = Category.find_or_create_by category_params
    if @category.valid?
      current_user.user_categoryships.create category: @category
      render json: { status: 200, category: @category}        
    else
      render json: { status: 400, error: @category.errors.full_messages[0] }
    end
  end

  def destroy
  end

  private
    def category_params
      params.require(:category).permit(:name)
    end

    def get_category
      @category = current_user.categories.find_by category_params
    end

    def limit_add_default_category
      if Category::DEFAULT.include? category_params[:name]
        render json: { status: 400, error: I18n.t("errors.category_has_existed", name: category_params[:name]) }
      end
    end
end