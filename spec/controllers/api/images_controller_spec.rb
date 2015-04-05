require 'rails_helper'

RSpec.describe Api::ImagesController, type: :controller do
  describe "POST #create" do
    before(:each) do
      FactoryGirl.create(:post)
    end

    context "with valid params" do
      it "creates a new image for a post in the system" do
        expect(Post.first.images.count).to eq 0
        new_image = FactoryGirl.attributes_for(:image)
        post :create, image: new_image, format: :json
        expect(Post.first.images.count).to eq 1
        expect(response).to have_http_status(201)
      end
    end

    context "with invalid params" do
      it "returns error message" do
      end
    end
  end
end
