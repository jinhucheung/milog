class HoldsController < ApplicationController
  before_action :check_signed_in
  before_action :check_activated
  before_action :get_user

  def update
    @hold = @user.hold params[:by]
    return render_404 unless @hold
    @hold.update_attributes hold_params
    if @hold.valid?
      render json: { status: 200, success: I18n.t("success.content_has_saved") }
      @hold.update_attribute :cleaned, false
    else
      render json: { status: 400, error: I18n.t("errors.paramater_illegal") }
    end
  end

  private 
    def hold_params
      params.require(:hold).permit :content, :title, :category_id, :tagstr, :holdable_id
    end

    def get_user
      @user = current_user
    end
end
