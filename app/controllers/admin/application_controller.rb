class Admin::ApplicationController < ApplicationController
  before_action :check_signed_in
  before_action :check_activated
  before_action :check_admin

  before_action :get_current_user, except: [:destroy]

  layout 'admin'

  MAX_IN_PAGE = 15

  def get_current_user
    @user = current_user
  end

  def delete_cache_pictures
    if user = current_user
      user.delete_cache_pictures
    end
  end

end