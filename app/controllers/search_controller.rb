class SearchController < ApplicationController
  before_action :check_disabled_user, only: [:show]
  before_action :get_token
  before_action :get_user, only: [:show]

  def show
    @articles = Article.search_by_token @token, user: @user
    @article_size = @articles.size
    respond_to do |format|
      format.js
      format.html { render :articles, layout: 'blog' }
    end
  end

  def index
    @articles = Article.search_by_token @token
    @article_size = @articles.size
    respond_to do |format|
      format.js { render :show }
      format.html { render :articles, layout: 'community' }
    end
  end

  private
    def get_token
      return render_404 if (@token = params[:token]).blank?
    end

    def get_user
      return render_404 if params[:id].blank?
      @user = User.find_by username: params[:id]
    end

end