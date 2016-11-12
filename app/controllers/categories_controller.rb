class CategoriesController < ApplicationController
  before_action :check_signed_in, only: [:create, :destroy, :update]
  before_action :check_activated, only: [:create, :destroy, :update]

  before_action :limit_add_or_update_default_category, only: [:create, :update]
  before_action :get_category_by_name, only: [:create]
  before_action :has_existed, only: [:create]

  before_action :limit_del_or_update_default_category, only: [:destroy, :update]
  before_action :get_category_by_id, only: [:destroy, :update]
  before_action :is_not_found, only: [:destroy, :update]

  def create
    @category = Category.find_or_create_by category_params
    if @category.valid?
      current_user.user_categoryships.create category: @category
      render_success  
    else
      render_errror @category.errors.full_messages[0]
    end
  end

  def destroy
    current_user.user_categoryships.find_by(category: @category).destroy
    current_user.user_categoryships.reload
    render_success I18n.t("success.category_has_deleted", name: @category.name)
  end

  def update
    bef_name = @category.name
    return has_existed if get_category_by_name
    @category = Category.find_by category_params
    # Category中没有此分类,直接改名
    unless @category
      get_category_by_id
      @category.update_attributes category_params
      if @category.valid?
        return render_success I18n.t("success.category_has_updated", bef_name: bef_name, upd_name: @category.name) 
      else
        return render_errror @category.errors.full_messages[0]     
      end
    end

    #当前分类的文章指向新分类
    articles = current_user.articles.select(:id).where(category_id: params[:id])
    if articles.any?
      articles.update_all category_id: @category.id
    end
    # 用户-分类关系重新指向
    current_user.user_categoryships.create category: @category
    current_user.user_categoryships.find_by(category_id: params[:id]).destroy
    render_success I18n.t("success.category_has_updated", bef_name: bef_name, upd_name: @category.name)
  end

  private
    def category_params
      params.require(:category).permit(:name)
    end

    def get_category_by_name
      @category = current_user.categories.find_by category_params
    end

    def get_category_by_id
      @category = current_user.categories.find_by id: params[:id]
    end

    def has_existed
      if @category
        render_errror I18n.t("errors.category_has_existed", name: @category.name)
      end
    end

    def is_not_found
      unless @category
        render_errror I18n.t("errors.category_not_fount")
      end
    end

    def limit_add_or_update_default_category
      if Category::DEFAULT.include? category_params[:name]
        render_errror I18n.t("errors.category_has_existed", name: category_params[:name]) 
      end
    end

    def limit_del_or_update_default_category
      if params[:id] == '1' || params[:id] == 1
       render_errror I18n.t("errors.opt_illegal") 
      end
    end

    def render_success(msg = '')
      render json: { status: 200, category: @category, success: msg }
    end

    def render_errror(msg = '')
      render json: { status: 400, error: msg }
    end
end