class Api::PostsController < ApplicationController
  respond_to :json

  def index
    render json: Post.order(updated_at: :desc)
  end

  def create
    post_params = params.require(:post).permit(:title, :content, user: :id, images: :url)
    post_params[:user] = User.find(post_params[:user][:id])
    p = Post.new(post_params)
    if p.valid? and p.save
      render json: p, status: :created
    else
      render json: { errors: p.errors }, status: :unprocessable_entity
    end
  end

  def show
    render json: Post.find(params.require(:id))
  end

  def update
    begin
      post_params = params.require(:post).permit(:title, :content, user: :id, images: :url)
      p = Post.find(params[:id])
      if p.valid? and p.update(post_params)
        render json: p
      else
        render json: { errors: p.errors }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: { id: [e.message] } }, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      condemned = Post.find(params[:id])
      condemned.destroy
      head :no_content
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: { id: [e.message] } }, status: :unprocessable_entity
    end
  end
end
