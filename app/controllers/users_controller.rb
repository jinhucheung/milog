class UsersController < ApplicationController
  before_action :get_user, only: [:show, :aboutme]

  layout 'blog'

  def show
  end

  def aboutme
  end

  private
    def get_user
      @user = User.find_by username: params[:id]
      render_404 unless @user
    end
end
