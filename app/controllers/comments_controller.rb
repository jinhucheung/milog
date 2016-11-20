class CommentsController < ApplicationController
  before_action :check_signed_in
  before_action :check_activated
  before_action :get_user

  before_action :get_comment, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def create
    @comment = @user.comments.create comment_params
  end

  def edit
    @content = @comment.content.gsub /\r\n/, '\r\n'
  end

  def reply
    @reply = Comment.select(:id, :index).find_by id: params[:id]
    render_404 unless @reply
  end

  def update
    cparams = params[:comment]
    @comment.update_attributes content: cparams[:content], content_html: cparams[:content_html]
  end

  def destroy
    @comment.update_attribute :deleted_at, Time.zone.now
  end

  private
  def comment_params
    params.require(:comment).permit(:article_id, :content, :content_html, :reply_id)
  end

  def get_user
    @user = current_user
  end

  def get_comment
    @comment = Comment.find_by id: params[:id]
    render_404 unless @comment
  end

  def correct_user
    render_404 unless current_user == @comment.user
  end

end
