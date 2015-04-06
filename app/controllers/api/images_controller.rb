class Api::ImagesController < ApplicationController
  respond_to :json

  def create
    image_params = params.require(:image).permit(:url, post: :id)
    image_params[:post] = Post.find(image_params[:post][:id])
    i = Image.new(image_params)
    if i.valid? and i.save
      render json: i, status: :created
    else
      render json: { errors: i.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      image = Image.find(params[:id])
      image.destroy
      head :no_content
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: { id: [e.message] } }, status: :unprocessable_entity
    end
  end
end
