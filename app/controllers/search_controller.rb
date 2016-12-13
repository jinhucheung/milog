class SearchController < ApplicationController
  before_action :check_disabled_user, only: [:show]
  before_action :check_params, only: [:show]

  def show
    @articles = Article.search_by_token @token, user: @user
  end

  def index
    @articles = Article.search_by_token params[:search][:keyword]
    render :show
  end

  private 
    def check_params
      return render_404 unless params[:id] && params[:search] && params[:search][:keyword]
      @user = User.find_by username: params[:id]
      @token = params[:search][:keyword]
    end

end