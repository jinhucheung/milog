class Admin::TagsController < Admin::ApplicationController

  def index
    case params[:by]
    when 'used'
      @value = 2
      @tags = Tag.used.reorder(id: :asc).paginate page: params[:page], per_page: MAX_IN_PAGE
    when 'unused'
      @value = 3
      @tags = Tag.unused.reorder(id: :asc).paginate page: params[:page], per_page: MAX_IN_PAGE
    else 
      @value = 1
      @tags = Tag.all.reorder(id: :asc).paginate page: params[:page], per_page: MAX_IN_PAGE
    end
  end

  def destroy
    @tag = Tag.find_by_id params[:id]
    if @tag
      @tag.destroy
      flash[:success] = I18n.t "flash.success.delete_tag", value: @tag.id
    else
      flash[:warning] = I18n.t "flash.warning.tag_not_fount", value: params[:id]
    end
    redirect_to admin_tags_path    
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new tag_params
    if @tag.save
      flash[:success] = I18n.t "flash.success.create"
      redirect_to admin_tags_path
    else
      flash.now[:warning] = @tag.errors.full_messages[0]
      render 'new'
    end
  end

  def edit
    @tag = Tag.find_by_id params[:id]
    return render_404 unless @tag
  end

  def update
    @tag = Tag.find_by_id params[:id]
    if @tag.update_attributes tag_params
      flash[:success] = I18n.t "flash.success.update"
      redirect_to admin_tags_path
    else
      flash.now[:warning] = @tag.errors.full_messages[0]
      render 'edit'
    end
  end

  private
    def tag_params
      params.require(:tag).permit :name
    end
end