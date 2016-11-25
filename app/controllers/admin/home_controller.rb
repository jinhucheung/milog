class Admin::HomeController < ApplicationController
  layout 'blog'

  def index
    @user = current_user
  end

  def test
    render json: { msg: '412' }
  end
end
