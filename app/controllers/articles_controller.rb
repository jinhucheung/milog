class ArticlesController < ApplicationController
  before_action :check_signed_in, except: [:show]
  before_action :check_activated, except: [:show]

  layout 'blog'

  def index
    redirect_to user_path(current_user.username)
  end

  def new
    get_current_user_and_category
    @article = current_user.articles.build
  end

  def create
    get_current_user_and_category article_params[:category_id]
    @article = current_user.articles.build article_params
    if @article.save
      @article.str2tags @article.tagstr
    else
      flash.now[:warning] = @article.errors.full_messages[0]
      return render 'new'
    end

    if params[:article][:save]
      flash.now[:success] = I18n.t "flash.success.save_article"
      render 'edit'
    elsif params[:article][:post]
      redirect_to article_path(@article.id)
    else
      redirect_to root_path
    end
  end

  def show
    @article = Article.find_by_id params[:id]
    return render_404 unless @article
    get_user_category_and_tags
    get_next_or_pre_article
  end

  def edit
    @article = current_user.articles.find params[:id]
    get_current_user_and_category @article.category_id
    @article.tagstr = @article.tags2str
  end

  private
    def get_user
      @user = User.find_by username: params[:user_id]
      render_404 unless @user
    end

    def article_params
      params.require(:article).permit(:title, :category_id, :content, :tagstr)
    end

    def get_current_user_and_category(category_id = 1)
      @user = current_user
      @category =current_user.categories.find_by id: category_id
      @categories = current_user.categories
    end

    def get_user_category_and_tags
      return if @article.blank?
      @user = @article.user
      @category = @article.category
      @tags = @article.tags
    end

    # 获取当前文章的上下篇
    def get_next_or_pre_article 
      return unless @user
      articles = @user.articles.to_a
      return if articles.size < 2
      index = articles.index @article
      @next_article = @pre_article = nil
      @next_article = articles[index+1] if index < articles.size-1
      @pre_article = articles[index-1] if index > 0
    end
end
