class ArticlesController < ApplicationController
  before_action :check_signed_in, expect: [:show, :index]
  before_action :check_activated, expect: [:show, :index]

  layout 'blog'

  def new
    @user = current_user
    @article = current_user.articles.build
    @category = current_user.categories.find_by name: 'default'
    @categories = current_user.categories
  end

  private
    def get_user
      @user = User.find_by username: params[:user_id]
      render_404 unless @user
    end

    def valid_user
      render_404 unless current_user == @user
    end
end
