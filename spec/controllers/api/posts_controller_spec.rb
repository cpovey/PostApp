require 'rails_helper'

RSpec.describe Api::PostsController, type: :controller do
  describe "GET #list" do
    before(:each) do
      FactoryGirl.create :post
      FactoryGirl.create :another_post
      get :list, format: :json
    end

    it "returns list of most recent posts" do
      expect(JSON.parse(response.body).count).to eql 2
    end

    it "returns success code" do
      expect(response).to have_http_status(200)
    end
 end
end
