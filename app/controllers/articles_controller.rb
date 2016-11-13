class ArticlesController < ApplicationController
  before_action :check_signed_in, expect: [:show]
  before_action :check_activated, expect: [:show]

  layout 'blog'

  def index
    redirect_to user_path(current_user.username)
  end

  def new
    get_user_and_category
    @article = current_user.articles.build
  end

  def create
    get_user_and_category article_params[:category_id]
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
    @article = current_user.articles.build
    get_user_and_category
  end

  def edit
    @article = current_user.articles.build
    get_user_and_category
  end

  private
    def get_user
      @user = User.find_by username: params[:user_id]
      render_404 unless @user
    end

    def article_params
      params.require(:article).permit(:title, :category_id, :content, :tagstr)
    end

    def get_user_and_category(category_id = 1)
      @user = current_user
      @category =current_user.categories.find_by id: category_id
      @categories = current_user.categories
    end
end
