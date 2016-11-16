class PicturesController < ApplicationController
  before_action :check_signed_in
  before_action :check_activated

  def create
    picture = current_user.pictures.create picture: params[:file]
    if picture.valid?
      render json: { status: 200, url: picture.picture.url }
    else
      render json: { status: 400, msg: picture.errors.full_messages[0] }
    end
  end

end