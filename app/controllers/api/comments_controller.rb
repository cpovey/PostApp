class Api::CommentsController < ApplicationController
  respond_to :json

  def index
    render json: Post.find(params[:post_id]).comments.order(updated_at: :asc)
  end

  def create
    comment_params = params.require(:comment).permit(:content, user: :id, post: :id, parent: :id)
    comment_params[:user] = User.find(comment_params[:user][:id])
    comment_params[:post] = Post.find(comment_params[:post][:id])
    comment_params[:parent] = Comment.find(comment_params[:parent][:id]) if comment_params[:parent]
    c = Comment.new(comment_params)
    if c.valid? and c.save
      render json: c, status: :created
    else
      render json: { errors: c.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      condemned = Comment.find(params[:id])
      condemned.destroy
      head :no_content
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: { id: [e.message] } }, status: :unprocessable_entity
    end
  end
end
