class Admin::UsersController < Admin::ApplicationController

  def index
    case params[:by]
    when 'normal'
      @value = 2
      @users = User.normal.paginate page: params[:page], per_page: MAX_IN_PAGE
    when 'admin'
      @value = 3
      @users = User.admin.paginate page: params[:page], per_page: MAX_IN_PAGE
    when 'disabled'
      @value = 4
      @users = User.disabled.paginate page: params[:page], per_page: MAX_IN_PAGE
    else 
      @value = 1
      @users = User.all.paginate page: params[:page], per_page: MAX_IN_PAGE
    end
  end

  def destroy
    @user = User.find_by username: params[:id]
    if @user
      @user.destroy
      flash[:success] = I18n.t "flash.success.delete_user", name: @user.username
    else
      flash[:warning] = I18n.t "flash.warning.user_not_fount", name: params[:id]
    end
    redirect_to admin_users_path
  end

  def new
    @new_user = User.new
    @random_psw = @new_user.new_random_psw
  end

  def create
    @new_user = User.new new_user_params
    if @new_user.valid?
      @new_user.save
      @new_user.generate_activation_digest
      AccountsMailer.active_account(@new_user, @new_user.password).deliver
      flash.now[:success] = I18n.t "flash.success.create_user", name: @new_user.username
    else
      @random_psw = @new_user.new_random_psw
      flash.now[:warning] = @new_user.errors.full_messages[0]
    end
    render 'new'
  end

  def edit
    @edit_user = User.find_by username: params[:id]
    if @edit_user.blank?
      flash[:warning] = I18n.t "flash.warning.user_not_fount", name: params[:id]
      redirect_to admin_users_path
    end 
  end

  def update
    @edit_user = User.find_by username: params[:id]
    if @edit_user.blank?
      flash[:warning] = I18n.t "flash.warning.user_not_fount", name: params[:id]
      return redirect_to admin_users_path
    end

    @edit_user.update_attributes edit_user_params
    if @edit_user.errors.include?(:email) || @edit_user.errors.include?(:username)
      flash.now[:warning] = I18n.t "flash.warning.username_or_email_has_existed"
    else
      @edit_user.update_attributes_by_each edit_user_params
      flash.now[:success] = I18n.t "flash.success.update_account"
    end
    @edit_user.reload
    render 'edit'
  end

  private
    def new_user_params
      params.require(:user).permit :username, :email, :password, :password_confirmation, :state
    end

    def edit_user_params
      params.require(:user).permit :username, :email, :state, :activated
    end
end