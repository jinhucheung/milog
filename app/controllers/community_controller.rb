class CommunityController < ApplicationController

  before_action :get_user

  layout 'community'

  def index
    @hottest_articles = Article.hottest.reorder(nil).order(created_at: :desc).limit 10
    @latest_articles = Article.where(posted: true).limit 10
  end

  def hottest
    hottest_articles = Article.hottest
    hottest_articles =
      case params[:order]
        when 'time'
          hottest_articles.reorder(nil).order created_at: :desc
        when 'view'
          hottest_articles.reorder(nil).order view_count: :desc
        when 'comment'
          hottest_articles
        else
          hottest_articles.reorder(nil).order created_at: :desc
      end
    @articles = hottest_articles.paginate page: params[:page], per_page: 15
  end

  def latest
  end

  def tag
    @tag = Tag.find_by_id params[:id]
    return render_404 unless @tag
    posted_articles = @tag.articles.where posted: true
    @article_size = posted_articles.size
    @articles = posted_articles.paginate page: params[:page], per_page: 15
  end

  private 
    def get_user
      @user = current_user if signed_in?
    end

end