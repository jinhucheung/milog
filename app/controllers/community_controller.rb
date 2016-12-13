class CommunityController < ApplicationController

  before_action :get_user

  layout 'community'

  def index
    @hottest_articles = Article.hottest.order_by_time.limit 10
    @latest_articles = Article.latest.order_by_time.limit 10
    # 活跃会员 当月发文数前12
    @users =  Article.all_during_time(Article.latest, time: :month)
                     .map{|article| article.user }.uniq
                     .sort{|user| user.articles.size}[0...12]
  end

  def hottest
    hottest_articles = Article.hottest
    hottest_articles = order hottest_articles
    @articles = hottest_articles.paginate page: params[:page], per_page: 15
    articles_during_time hottest_articles
  end

  def latest
    latest_articles = Article.latest
    latest_articles = order latest_articles
    @articles = latest_articles.paginate page: params[:page], per_page: 15
    articles_during_time latest_articles    
  end

  def tag
    @tag = Tag.find_by_id params[:id]
    return render_404 unless @tag
    posted_articles = @tag.articles.where posted: true
    @article_size = posted_articles.size
    @articles = posted_articles.paginate page: params[:page], per_page: 15
  end

  def articles
    articles = 
      case params[:by]
        when 'hottest_today'
          @page_title = I18n.t "community.hottest_today_pre"
          Article.all_during_time Article.hottest, time: :day
        when 'hottest_tweek'
          @page_title = I18n.t "community.hottest_tweek_pre"
          Article.all_during_time Article.hottest, time: :week
        when 'hottest_tmonth'
          @page_title = I18n.t "community.hottest_tmonth_pre"
          Article.all_during_time Article.hottest, time: :month
        when 'latest_today'
          @page_title = I18n.t "community.latest_today_pre"
          Article.all_during_time Article.latest, time: :day
        when 'latest_tweek'
          @page_title = I18n.t "community.latest_tweek_pre"
          Article.all_during_time Article.latest, time: :week
        when 'latest_tmonth'
          @page_title = I18n.t "community.latest_tmonth_pre"
          Article.all_during_time Article.latest, time: :month
        else
          @page_title = I18n.t "article.all"
          Article.where posted: true
      end      
    @article_size = articles.size
    @articles = articles.paginate page: params[:page], per_page: 15
  end

  def users
    users = User.abled
    @user_size = users.size
    @users = users.paginate page: params[:page], per_page: 60
  end

  private 
    def get_user
      @user = current_user if signed_in?
    end

    def order(articles)
      return nil if articles.blank?
      case params[:order]
        when 'time'
          @opt = 0
          articles.order_by_time
        when 'view'
          @opt = 1
          articles.order_by_view_count
        when 'comment'
          @opt = 2
          articles
        else
          @opt = 0
          articles.order_by_time
      end
    end

    def articles_during_time(articles)
      @articles_today_size = Article.all_during_time(articles, time: :day).size 
      @articles_curweek_size = Article.all_during_time(articles, time: :week).size
      @articles_curmonth_size = Article.all_during_time(articles, time: :month).size
    end
end