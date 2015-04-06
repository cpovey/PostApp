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
        new_image[:post] = {id: Post.first.id}
        post :create, image: new_image, format: :json
        expect(Post.first.images.count).to eq 1
        expect(response).to have_http_status(201)
      end
    end

    context "with invalid params" do
      it "returns error message" do
        post :create, image: { post: {id: Post.first.id}}, format: :json # no url specified
        err_resp = JSON.parse(response.body, symbolize_names: true)
        expect(err_resp).to have_key(:errors)
        expect(err_resp[:errors][:url]).to include "can't be blank"
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the image" do
      FactoryGirl.create(:image)
      expect(Image.count).to eq 1
      delete :destroy, id: Image.first.id, format: :json
      expect(Image.count).to eq 0
      expect(response).to have_http_status(204)
    end

    it "returns error if id is invalid" do
      FactoryGirl.create(:image)
      expect(Image.count).to eq 1
      delete :destroy, id: 999, format: :json
      expect(Image.count).to eq 1
      err_resp = JSON.parse(response.body, symbolize_names: true)
      expect(err_resp[:errors][:id]).to include "Couldn't find Image with 'id'=999"
      expect(response).to have_http_status(422)
    end
  end
end
