class UsersController < ApplicationController
  before_action :get_user

  before_action :check_signed_in, only: [:drafts]
  before_action :check_activated, only: [:drafts]
  before_action :correct_user, only: [:drafts]

  layout 'blog'

  def show
  end

  def aboutme
  end

  def categories
  end

  def drafts
    @articles = @user.articles.where posted: false
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
