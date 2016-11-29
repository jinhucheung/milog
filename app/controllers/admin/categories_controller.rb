class Admin::CategoriesController < Admin::ApplicationController

  def index
    case params[:by]
    when 'used'
      @value = 2
      @categories = Category.used.reorder(id: :asc).paginate page: params[:page], per_page: MAX_IN_PAGE
    when 'unused'
      @value = 3
      @categories = Category.unused.reorder(id: :asc).paginate page: params[:page], per_page: MAX_IN_PAGE
    when 'ships'
      @value = 4
      @user_categoryships = UserCategoryship.all.reorder(id: :asc).paginate page: params[:page], per_page: MAX_IN_PAGE
    else 
      @value = 1
      @categories = Category.all.reorder(id: :asc).paginate page: params[:page], per_page: MAX_IN_PAGE
    end
  end

  def destroy
    get_category_or_user_cateogryship

    select_opts =
      if params[:by] == 'ships'
        flash[:success] = I18n.t "flash.success.delete_user_categoryship", value: params[:id]
        { user_id: @object.user_id, category_id: @category_id }
      else
        flash[:success] = I18n.t "flash.success.delete_category", value: params[:id]
        { category_id: @category_id }
      end

    # 迁移文章至默认分类
    articles = Article.select(:id).where select_opts
    articles.update_all category_id: 1 if articles.any?
    @object.destroy
    redirect_to admin_categories_path
  end

  def new
    @name = @user_id = nil
  end

  def create
    @name = params[:category][:name]
    @user_id = params[:category][:user_id]

    # 查找/添加分类
    _category = Category.find_or_create_by name: @name
    unless _category.valid?
      flash.now[:warning] = _category.errors.full_messages[0]
      return render 'new'      
    end

    # 添加用户分类关系
    unless @user_id.blank?
      _ship = UserCategoryship.new user_id: @user_id, category: _category
      unless _ship.save
        flash.now[:warning] = _ship.errors.full_messages[0]
        return render 'new'
      end
    end
    flash[:success] = I18n.t "flash.success.create"
    redirect_to admin_categories_path
  end

  def edit
    get_category_or_user_cateogryship

    if params[:by] == 'ships'
      @name = @object.category.name
      @user_id = @object.user_id
    else
      @name = @object.name
      @only_category = true
    end
  end

  def update
    get_category_or_user_cateogryship

    @name = params[:category][:name]
    @user_id = params[:category][:user_id]

    if params[:by] == 'ships'
      _pre_category_id = @object.category_id
      _pre_user_id = @object.user_id
      unless (_category = Category.find_or_create_by(name: @name)) && @object.update_attributes(category: _category, user_id: @user_id)
        flash.now[:warning] = _category.errors.full_messages[0] || @object.errors.full_messages[0]
        return render 'edit'
      end
      # 对与用户分类关系
      # 当只改变分类名时, 迁移用户的文章
      # 当改变了用户ID时, 等价于创建新用户的分类关系, 加创建回原用户的分类关系
      if _pre_user_id == @object.user_id 
        articles = Article.select(:id).where(category_id: _pre_category_id, user_id: _pre_user_id)
        articles.update_all category_id: @object.category_id if articles.any?
      else
        User.find_by_id(_pre_user_id).user_categoryships.create category_id: _pre_category_id
      end
      
    else
      unless @object.update_attributes name: @name
        flash.now[:warning] = @object.errors.full_messages[0]
        @only_category = true
        return render 'edit'        
      end
    end

    flash[:success] = I18n.t "flash.success.update"
    redirect_to admin_categories_path  
  end

  private
    def limit_default_category
      # 禁止删除默认分类
      if @category_id == 1
        flash.delete :success
        flash[:danger] = I18n.t "flash.danger.default_category_change"
        return redirect_to admin_categories_path  
      end
    end

    def get_category_or_user_cateogryship
      @object = 
        if params[:by] == 'ships'
          UserCategoryship.find_by_id params[:id]
        else
          Category.find_by_id params[:id]
        end

      unless @object
        flash[:warning] = params[:by] == 'ships' ?  I18n.t("flash.warning.user_categoryship_not_fount", value: params[:id]) :
                                                    flash[:warning] = I18n.t("flash.warning.category_not_fount", value: params[:id])
        return redirect_to admin_categories_path                          
      end

      @category_id = params[:by] == 'ships' ?  @object.category_id : @object.id

      # 禁止更改默认分类
      limit_default_category
    end

end