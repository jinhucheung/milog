class UsersController < ApplicationController
  before_action :get_user
  before_action :check_disabled_user
  before_action :check_signed_in, only: [:drafts]
  before_action :check_activated, only: [:drafts]
  before_action :correct_user, only: [:drafts]

  layout 'blog'

  def show
    @articles = @user.articles.where(posted: true).paginate page: params[:page], per_page: 5
  end

  def aboutme
  end

  def categories
    @categories = @user.categories
    @tags = @user.tags
  end

  def drafts
    @articles = @user.articles.where posted: false
  end

  def archive
    total_articles = @user.articles.where(posted: true)
    articles_group_by_year total_articles
  end

  def category
    @category = @user.categories.find_by_id params[:category_id]
    return render_404 unless @category
    total_articles = @category.posted_articles @user
    articles_group_by_year total_articles
  end

  def tag
    user_tags = @user.tags
    tag_index = user_tags.index { |tag| tag.id == params[:tag_id].to_i }
    return render_404 unless tag_index
    @tag = user_tags[tag_index]
    total_articles = @tag.posted_articles @user
    articles_group_by_year total_articles
  end

  private
    def get_user
      @user = User.find_by username: params[:id]
      render_404 unless @user
    end

    def correct_user
      render_404 unless current_user == @user
    end

    # 按年份将文章分组
    def articles_group_by_year(total_articles)
      @articles_total_size = total_articles.size
      @paginated_articles = total_articles.paginate page: params[:page], per_page: 20
      @articles_by_year = @paginated_articles.to_a.group_by(&:posted_year).map { |year_article| year_article }      
    end
end
