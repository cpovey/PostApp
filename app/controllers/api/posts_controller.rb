class Api::PostsController < ApplicationController
  respond_to :json

  def list
    respond_with Post.all
  end
end
