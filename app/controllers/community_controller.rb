class CommunityController < ApplicationController

  before_action :get_user

  layout 'community'

  def index
  end

  def hottest
  end

  def latest
  end

  private 
    def get_user
      @user = current_user if signed_in?
    end

end