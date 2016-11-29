class Admin::CommentsController < Admin::ApplicationController
  before_action :delete_cache_pictures, only: [:new, :edit, :index]

  def index
    case params[:by]
    when 'posted'
      @value = 2
      @comments = Comment.posted.reorder(id: :asc).paginate page: params[:page], per_page: MAX_IN_PAGE
    when 'deleting'
      @value = 3
      @comments = Comment.deleting.reorder(id: :asc).paginate page: params[:page], per_page: MAX_IN_PAGE
    else 
      @value = 1
      @comments = Comment.all.reorder(id: :asc).paginate page: params[:page], per_page: MAX_IN_PAGE
    end
  end

  def destroy
    @comment = Comment.find_by_id params[:id]
    if @comment
      @comment.destroy
      flash[:success] = I18n.t "flash.success.delete_comment", value: @comment.id
    else
      flash[:warning] = I18n.t "flash.warning.comment_not_fount", value: params[:id]
    end
    redirect_to admin_comments_path
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new comment_new_params
    _user = User.find_by_id comment_new_params[:user_id]
    unless _user
      flash.now[:warning] = I18n.t "flash.warning.user_not_fount_by_id", value: comment_new_params[:user_id]
      return render 'new'
    end

    _article = Article.find_by_id comment_new_params[:article_id]
    unless _article
      flash.now[:warning] = I18n.t "flash.warning.article_not_fount", value: comment_new_params[:article_id]
      return render 'new'
    end

    if @comment.save
      flash[:success] = I18n.t "flash.success.create"
      @comment.update_attribute :deleted_at, Time.zone.now  if params[:comment][:deleted].downcase == "true"
      redirect_to admin_comments_path
    else
      flash.now[:warning] = @comment.errors.full_messages[0]
      render 'new'
    end
  end

  def edit
    @comment = Comment.find_by_id params[:id]
    return render_404 unless @comment
  end

  def update
    @comment = Comment.find_by_id params[:id]
    return render_404 unless @comment

    if @comment.update_attributes comment_edit_params
      deleted = params[:comment][:deleted].downcase == "true" ? Time.zone.now : ''
      @comment.update_attribute :deleted_at, deleted
      flash[:success] = I18n.t "flash.success.update"
      redirect_to admin_comments_path
    else
      flash.now[:warning] = @comment.errors.full_messages[0]
      render 'edit'
    end
  end

  private
    def comment_new_params
      params.require(:comment).permit :content, :content_html,
                                      :user_id, :article_id, :reply_id
    end

    def comment_edit_params
      params.require(:comment).permit :content, :content_html, :reply_id
    end
end