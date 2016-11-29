class Admin::PicturesController < Admin::ApplicationController

  def index
    case params[:by]
    when 'posted'
      @value = 2
      @pictures = Picture.posted.reorder(nil).paginate page: params[:page], per_page: MAX_IN_PAGE
    when 'unposted'
      @value = 3
      @pictures = Picture.unposted.reorder(nil).paginate page: params[:page], per_page: MAX_IN_PAGE
    else 
      @value = 1
      @pictures = Picture.all.reorder(nil).paginate page: params[:page], per_page: MAX_IN_PAGE
    end
  end

  def destroy
    @picture = Picture.find_by_id params[:id]
    if @picture
      @picture.destroy
      flash[:success] = I18n.t "flash.success.delete_picture", value: params[:id]
    else
      flash[:warning] = I18n.t "flash.warning.picture_not_fount", value: params[:id]
    end
    redirect_to admin_pictures_path
  end

  def create
    @picture = current_user.pictures.new picture: params[:picture][:file], posted: true
    if @picture.save
      flash[:success] = I18n.t "flash.success.create"
    else
      flash[:warning] = @picture.errors.full_messages[0]
    end
    redirect_to admin_pictures_path
  end

end