class ArticlesController < ApplicationController
  before_action :get_user
  before_action :check_signed_in, expect: [:show, :index]
  before_action :valid_user, expect: [:show, :index]
  before_action :check_activated, expect: [:show, :index]

  layout 'blog'

  def new
    @article = current_user.articles.build
    @category = Category.first_or_create name: 'default'
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
