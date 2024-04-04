# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create]
  before_action :set_comment, only: %i[destroy]
  before_action :authorize_owner, only: %i[destroy]

  def create
    @comment = @commentable.comments.build(comment_params)

    if @comment.save
      redirect_to @comment.commentable, flash: { success: t('defaults.message.created', item: Comment.model_name.human) }
    else
      redirect_to @comment.commentable, flash: { danger: t('defaults.message.not_created', item: Comment.model_name.human) }
    end
  end

  def destroy
    @comment.destroy
    redirect_to @comment.commentable, flash: { success: t('defaults.message.destroyed', item: Comment.model_name.human) }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end

  def authorize_owner
    return if current_user == @comment.user

    redirect_to report_url(@comment), notice: t('controllers.common.notice_no_permission', name: Comment.model_name.human)
  end
end
