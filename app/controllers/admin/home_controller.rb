class Admin::HomeController < ApplicationController
  layout 'admin'

  def index
    @user = current_user
  end

end
