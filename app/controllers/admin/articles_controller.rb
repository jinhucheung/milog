class Admin::ArticlesController < Admin::ApplicationController

  def index
    case params[:by]
    when 'posted'
      @value = 2
      @articles = Article.posted.reorder(nil).paginate page: params[:page], per_page: MAX_IN_PAGE
    when 'unposted'
      @value = 3
      @articles = Article.unposted.reorder(nil).paginate page: params[:page], per_page: MAX_IN_PAGE
    else 
      @value = 1
      @articles = Article.all.reorder(nil).paginate page: params[:page], per_page: MAX_IN_PAGE
    end
  end

  def destroy
    @article = Article.find_by_id params[:id]
    if @article
      @article.destroy
      flash[:success] = I18n.t "flash.success.delete_article", value: @article.id
    else
      flash[:warning] = I18n.t "flash.warning.article_not_fount", value: params[:id]
    end
    redirect_to admin_articles_path
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new article_params
    if @article.save
      @article.str2tags @article.tagstr
      flash[:success] = I18n.t "flash.success.create_article"
      redirect_to admin_articles_path
    else
      flash.now[:warning] = @article.errors.full_messages[0]
      render 'new'
    end
  end

  def edit
    @article = Article.find_by_id params[:id]
    return render_404 unless @article
    @article.tagstr = @article.tags2str
  end

  def update
    @article = Article.find_by_id params[:id]
    return render_404 unless @article
    if @article.update_attributes article_params
      @article.update_tags @article.tagstr
      flash.now[:success] = I18n.t "flash.success.update_article"
    else
      flash.now[:warning] = @article.errors.full_messages[0]
    end
    render 'edit'
  end

  private
    def article_params
      params.require(:article).permit :title, :content, :content_html, :tagstr, 
                                      :posted, :user_id, :category_id
    end
end