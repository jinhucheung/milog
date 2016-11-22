class SearchController < ApplicationController
  before_action :check_disabled_user
  before_action :check_params

  def index
    @articles = Article.search_by_token_in_user @token, @user
  end

  private 
    def check_params
      return render_404 unless params[:id] && params[:search] && params[:search][:keyword]
      @user = User.find_by username: params[:id]
      @token = params[:search][:keyword]
    end

end