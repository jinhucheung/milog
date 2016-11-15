class UsersController < ApplicationController
  before_action :get_user

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
  end

  def drafts
    @articles = @user.articles.where posted: false
  end

  def archive
    total_articles = @user.articles.where(posted: true)
    @articles_total_size = total_articles.size
    @articles = total_articles.paginate page: params[:page], per_page: 20
    @articles_by_year = @articles.to_a.group_by(&:posted_year).map { |year_article| year_article }
  end

  private
    def get_user
      @user = User.find_by username: params[:id]
      render_404 unless @user
    end

    def correct_user
      render_404 unless current_user == @user
    end
end
